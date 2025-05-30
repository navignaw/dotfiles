#!/usr/bin/env bash

# Kubernetes status line for tmux
# Displays current context and namespace, designed for primary-* clusters.
# Adapted and revised from https://github.com/jonmosco/kube-tmux
#
# Usage:
# Source this script in your ~/.config/tmux/tmux.conf file.
# For example, to put it in the right status bar:
# ```
# set -g status-interval 5  # how often to refresh your status bar
# set -g status-right '#(sh <path/to>/dotfiles/tmux_scripts/kubecontext.sh)'
# ```
# Then run: `tmux source-file ~/.config/tmux/tmux.conf`

# Copyright 2023 Jon Mosco
#
#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# If you'd like to configure these values, set them in your ~/.zshrc file:
# export KUBE_TMUX_X="value"
KUBE_TMUX_BINARY="${KUBE_TMUX_BINARY:-kubectl}"
KUBE_TMUX_SYMBOL_ENABLE="${KUBE_TMUX_SYMBOL_ENABLE:-false}"
KUBE_TMUX_SYMBOL_DEFAULT="${KUBE_TMUX_SYMBOL_DEFAULT:-\u2388 }"
KUBE_TMUX_SYMBOL_USE_IMG="${KUBE_TMUX_SYMBOL_USE_IMG:-false}"
KUBE_TMUX_NS_ENABLE="${KUBE_TMUX_NS_ENABLE:-true}"
KUBE_TMUX_DIVIDER="${KUBE_TMUX_DIVIDER:-/}"
KUBE_TMUX_SYMBOL_COLOR="${KUBE_TMUX_SYMBOL_COLOR:-blue}"
KUBE_TMUX_PREPROD_COLOR="${KUBE_TMUX_PREPROD_COLOR:-colour190}" # green
KUBE_TMUX_STAGING_COLOR="${KUBE_TMUX_STAGING_COLOR:-colour225}" # magenta
KUBE_TMUX_PROD_COLOR="${KUBE_TMUX_PROD_COLOR:-colour196}"       # red
KUBE_TMUX_NS_COLOR="${KUBE_TMUX_NS_COLOR:-colour195}"           # light blue
KUBE_TMUX_KUBECONFIG_CACHE="${KUBECONFIG}"
KUBE_TMUX_UNAME=$(uname)
KUBE_TMUX_LAST_TIME=0

KUBE_TMUX_NAMESPACE_FUNCTION="${KUBE_TMUX_NAMESPACE_FUNCTION}"

_kube_tmux_color_check() {
  # check if input contains primary-preprod
  if [[ $1 == *primary-preprod* ]]; then
    echo "#[fg=${KUBE_TMUX_PREPROD_COLOR}]$1"
  elif [[ $1 == *primary-staging* ]]; then
    echo "#[fg=${KUBE_TMUX_STAGING_COLOR}]$1"
  else
    echo "#[fg=${KUBE_TMUX_PROD_COLOR}]$1"
  fi
}

_kube_tmux_binary_check() {
  command -v $1 >/dev/null
}

_kube_tmux_symbol() {
  if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388 ' != "\\u2388 " ]]; then
    KUBE_TMUX_SYMBOL=$'\u2388 '
    KUBE_TMUX_SYMBOL_IMG=$'\u2638 '
  else
    KUBE_TMUX_SYMBOL=$'\xE2\x8E\x88 '
    KUBE_TMUX_SYMBOL_IMG=$'\xE2\x98\xB8 '
  fi

  if [[ "${KUBE_TMUX_SYMBOL_USE_IMG}" == true ]]; then
    KUBE_TMUX_SYMBOL="${KUBE_TMUX_SYMBOL_IMG}"
  fi

  echo "${KUBE_TMUX_SYMBOL}"
}

_kube_tmux_split() {
  type setopt >/dev/null 2>&1 && setopt SH_WORD_SPLIT
  local IFS=$1
  echo $2
}

_kube_tmux_file_newer_than() {
  local mtime
  local file=$1
  local check_time=$2

  if [[ "$KUBE_TMUX_UNAME" == "Linux" ]]; then
    mtime=$(stat -c %Y "${file}")
  elif [[ "$KUBE_TMUX_UNAME" == "Darwin" ]]; then
    # Use native stat in cases where gnutils are installed
    mtime=$(/usr/bin/stat -f %m "$file")
  fi

  [[ "${mtime}" -gt "${check_time}" ]]
}

_kube_tmux_update_cache() {
  if ! _kube_tmux_binary_check "${KUBE_TMUX_BINARY}"; then
    # No ability to fetch context/namespace; display N/A.
    KUBE_TMUX_CONTEXT="BINARY-N/A"
    KUBE_TMUX_NAMESPACE="N/A"
    return
  fi

  if [[ "${KUBECONFIG}" != "${KUBE_TMUX_KUBECONFIG_CACHE}" ]]; then
    # User changed KUBECONFIG; unconditionally refetch.
    KUBE_TMUX_KUBECONFIG_CACHE=${KUBECONFIG}
    _kube_tmux_get_context_ns
    return
  fi

  # kubectl will read the environment variable $KUBECONFIG
  # otherwise set it to ~/.kube/config
  local conf
  for conf in $(_kube_tmux_split : "${KUBECONFIG:-${HOME}/.kube/config}"); do
    [[ -r "${conf}" ]] || continue
    if _kube_tmux_file_newer_than "${conf}" "${KUBE_TMUX_LAST_TIME}"; then
      _kube_tmux_get_context_ns
      return
    fi
  done
}

_kube_tmux_get_context_ns() {
  # Set the command time
  if [[ "${KUBE_TMUX_SHELL}" == "bash" ]]; then
    if ((BASH_VERSINFO[0] >= 4)); then
      KUBE_TMUX_LAST_TIME=$(printf '%(%s)T')
    else
      KUBE_TMUX_LAST_TIME=$(date +%s)
    fi
  fi

  KUBE_TMUX_CONTEXT="$(${KUBE_TMUX_BINARY} config current-context 2>/dev/null)"
  # Remove everything up to the first slash
  KUBE_TMUX_CONTEXT="${KUBE_TMUX_CONTEXT#*/}"
  if [[ -z "${KUBE_TMUX_CONTEXT}" ]]; then
    KUBE_TMUX_CONTEXT="N/A"
    KUBE_TMUX_NAMESPACE="N/A"
    return
  elif [[ "${KUBE_TMUX_NS_ENABLE}" == true ]]; then
    KUBE_TMUX_NAMESPACE="$(${KUBE_TMUX_BINARY} config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    # Set namespace to 'default' if it is not defined
    KUBE_TMUX_NAMESPACE="${KUBE_TMUX_NAMESPACE:-default}"
  fi
  _kube_tmux_format_context_ns
}

_kube_tmux_format_context_ns() {
  KUBE_TMUX_CONTEXT=$(_kube_tmux_color_check $KUBE_TMUX_CONTEXT)
  if [[ -n "${KUBE_TMUX_NAMESPACE_FUNCTION}" ]]; then
    KUBE_TMUX_CONTEXT=$($KUBE_TMUX_NAMESPACE_FUNCTION $KUBE_TMUX_NAMESPACE)
  fi
}

kube_tmux() {
  _kube_tmux_update_cache

  local KUBE_TMUX

  # Symbol
  if [[ "${KUBE_TMUX_SYMBOL_ENABLE}" == true ]]; then
    KUBE_TMUX+="#[fg=blue]$(_kube_tmux_symbol)#[fg=colour${1}]"
  fi

  # Context
  KUBE_TMUX+="${KUBE_TMUX_CONTEXT}"

  # Namespace
  if [[ "${KUBE_TMUX_NS_ENABLE}" == true ]]; then
    if [[ -n "${KUBE_TMUX_DIVIDER}" ]]; then
      KUBE_TMUX+="#[fg=colour250]${KUBE_TMUX_DIVIDER}"
    fi
    KUBE_TMUX+="#[fg=${KUBE_TMUX_NS_COLOR}]${KUBE_TMUX_NAMESPACE}"
  fi

  echo "${KUBE_TMUX}"
}

kube_tmux "$@"
