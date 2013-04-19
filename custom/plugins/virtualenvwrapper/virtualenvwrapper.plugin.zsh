wrapsource=`which virtualenvwrapper_lazy.sh`

if [[ -f "$wrapsource" ]]; then
  source $wrapsource

  if [[ ! $DISABLE_VENV_CD -eq 1 ]]; then
	WORKON_HOME=~/Envs
	VIRTUAL_ENV_DISABLE_PROMPT=1
	ZSH_THEME_VE_PROMPT_PREFIX="["
	ZSH_THEME_VE_PROMPT_SUFFIX="]"
	
	# Allow better customisation with the prompt to show virtualenv
	function virtualenv_info() {
		if [[ $VIRTUAL_ENV == "" ]] then # No environment
			echo ""
		else
			echo "$ZSH_THEME_VE_PROMPT_PREFIX$(basename $VIRTUAL_ENV)$ZSH_THEME_VE_PROMPT_SUFFIX"
		fi
	}
	
    # Automatically activate Git projects' virtual environments based on the
    # directory name of the project. Virtual environment name can be overridden
    # by placing a .venv file in the project root with a virtualenv name in it
    function workon_cwd {
        # Check that this is a Git repo
        PROJECT_ROOT=`git rev-parse --show-toplevel 2> /dev/null`
        if (( $? == 0 )); then
            # Check for virtualenv name override
            ENV_NAME=`basename "$PROJECT_ROOT"`
            if [[ -f "$PROJECT_ROOT/.venv" ]]; then
                ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
            fi
            # Activate the environment only if it is not already active
            if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
                if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
                    workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
                fi
            fi
        elif [ $CD_VIRTUAL_ENV ]; then
            # We've just left the repo, deactivate the environment
            # Note: this only happens if the virtualenv was activated automatically
            deactivate && unset CD_VIRTUAL_ENV
        fi
        unset PROJECT_ROOT
    }

    # New cd function that does the virtualenv magic
    function cd {
        builtin cd "$@" && workon_cwd
    }
  fi
  
  # The use_env call below is a reusable command to activate/create a new Python
  # virtualenv, requiring only a single declarative line of code in your .env files.
  # It only performs an action if the requested virtualenv is not the current one.
  use_env() {
    typeset venv
    venv="$1"
    if [[ "${VIRTUAL_ENV:t}" != "$venv" ]]; then
      if workon | grep -q "$venv"; then
        workon "$venv"
      else
        echo -n "Create virtualenv $venv now? (Yn) "
        read answer
        if [[ "$answer" == "Y" ]]; then
          mkvirtualenv "$venv"
        fi
      fi
    fi
  }
else
  print "zsh virtualenvwrapper plugin: Cannot find virtualenvwrapper_lazy.sh. Please install with \`pip install virtualenvwrapper\`."
fi
