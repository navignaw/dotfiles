#!/usr/bin/env ruby
require 'cgi'
require 'pathname'
require 'shellwords'

if ARGV.size == 1
	filename = ARGV[0]
elsif ARGV.size == 2
	branch = ARGV[0]
	filename = ARGV[1]
else
	puts "usage: git link <filename>"
	puts "       git link <branch name> <filename>"
	abort
end

if filename.include? "#"
	# split the filename and line number
	filename, line_number = filename.split("#")
else
	line_number = nil
end

absolute_filename = File.expand_path(filename)

Dir.chdir File.dirname(filename) do
	worktree_root = File.expand_path(`git rev-parse --show-toplevel`.strip)
	abort unless $?.exitstatus === 0

	git_common_dir = File.expand_path(`git rev-parse --git-common-dir`.strip)
	abort unless $?.exitstatus === 0
	url_repo_root = File.dirname(git_common_dir)

	remote_origin = `git remote get-url origin`.strip
	abort unless $?.exitstatus === 0

	base_url = if remote_origin.start_with?('git@github.com')
		chunks = remote_origin.match(/^git@github.com:(.+)\/(.+)\.git$/)
		if chunks.size === 3
			"https://github.com/#{CGI.escape(chunks[1])}/#{chunks[2]}/blob"
		end
	end

	if base_url === nil
		puts "Not sure how to link to this repository: #{remote_origin}"
		abort
	end

	hash = `git log --format='%H' --max-count=1 -- #{absolute_filename.shellescape}`.strip
	abort unless $?.exitstatus === 0

	branch_or_hash = if branch != nil
		branch
	else
		hash
	end

	repo_relative_filename = Pathname.new(absolute_filename).relative_path_from(worktree_root).to_s
	relative_filename = Pathname.new(File.join(url_repo_root, repo_relative_filename)).relative_path_from(url_repo_root).to_s

  line_url = if line_number != nil
		line_number.start_with?("L") ? "\##{line_number}" : "\#L#{line_number}"
	else
		""
	end

	url = "#{base_url}/#{CGI.escape(branch_or_hash)}/#{relative_filename}#{line_url}"
	puts url
	`open #{url}`
end
