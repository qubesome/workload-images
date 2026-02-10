# Session Context

## User Prompts

### Prompt 1

workloads/cli-llm/Dockerfile installs claude into the target container, but fails to correctly set the PATH. When running the container I need to type the following command to be able to run claude. Fix this on the Dockerfile so that PATH is always correct.  export PATH="$HOME/.local/bin:$PATH"

### Prompt 2

Now lets add `claude --version` after its installation, to ensure it is working and fail during build otherwise.

### Prompt 3

Suggest a commit message

### Prompt 4

Yes

