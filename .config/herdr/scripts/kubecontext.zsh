# Publish the active Kubernetes context and namespace to the Herdr sidebar.
if [[ -n "$HERDR_WORKSPACE_ID" ]] && command -v herdr >/dev/null 2>&1; then
  typeset -gi _herdr_kubecontext_pid=0
  typeset -gi _herdr_kubecontext_refresh_pending=0

  _herdr_kubecontext_update() {
    local config context namespace

    if command -v kubectl >/dev/null 2>&1; then
      config=$(command kubectl config view --minify \
        --output='jsonpath={.current-context}{"\t"}{..namespace}' 2>/dev/null)
      IFS=$'\t' read -r context namespace <<< "$config"
    fi

    if [[ -n "$context" ]]; then
      context=${context#*/}
      context=${context#primary-}
      namespace=${namespace:-default}

      command herdr workspace report-metadata "$HERDR_WORKSPACE_ID" \
        --source kubecontext \
        --token "kubecontext=${context}/${namespace}" >/dev/null 2>&1
    else
      command herdr workspace report-metadata "$HERDR_WORKSPACE_ID" \
        --source kubecontext \
        --clear-token kubecontext >/dev/null 2>&1
    fi
  }

  _herdr_kubecontext() {
    setopt localoptions no_bg_nice

    # Never hold up the shell or start a second refresh while one is active.
    if (( _herdr_kubecontext_pid > 0 )) &&
      kill -0 "$_herdr_kubecontext_pid" 2>/dev/null; then
      return
    fi

    _herdr_kubecontext_update &!
    _herdr_kubecontext_pid=$!
  }

  _herdr_kubecontext_preexec() {
    # The second preexec argument contains the expanded command line, so this
    # also catches aliases that expand to kubectl.
    if [[ "$2" =~ '(^|[[:space:];|&])kubectl([[:space:];|&]|$)' ]]; then
      _herdr_kubecontext_refresh_pending=1
    fi
  }

  _herdr_kubecontext_precmd() {
    (( _herdr_kubecontext_refresh_pending )) || return 0
    _herdr_kubecontext_refresh_pending=0
    _herdr_kubecontext
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _herdr_kubecontext_preexec
  add-zsh-hook precmd _herdr_kubecontext_precmd

  # Populate the sidebar when a new shell starts.
  _herdr_kubecontext
fi
