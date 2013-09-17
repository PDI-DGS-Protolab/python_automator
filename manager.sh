#/bin/bash

###############################################################################
### FUNCTIONS #################################################################
###############################################################################

# Help function
function usage () {
cat << EOF

Usage: manager.sh [-h|-v|-c|-i|-r|-s]

OPTIONS:
   -h      Show this message
   -v      Verbose
   -c      Clones the repository
   -i
   -r
   -s      Syncs the database (creating it if not exists)

EOF
}

# Function that executes the given code checking the verbose option
function execute () {
    printf "$2... "
    if [[ $VERBOSE -eq 1 ]]; then
        eval $1
    else
        eval $1 &> /dev/null
    fi
    printf "Done\n"
}

function clone () {
    mkdir "$REPO_NAME"
    cd $REPO_NAME
    execute "virtualenv -p $PYTHON_PATH venv --distribute" "Creating virtual environment"

    execute "source venv/bin/activate" "Activating virtual environment"
    execute "git clone $REPO_URL" "Cloning repository from github"
}

function install () {

}

function run () {
    cd $REPO_NAME
    execute "source venv/bin/activate" "Activating virtual environment"
    cd $REPO_NAME

    execute "wget --output-document .env $AWS_URL" "Downloading .env"

    file=".env"
    while read line
    do
        if [ -z "$line" ]; then
            continue;
        fi

        value="export $line";
        echo $value;
        `$value`
    done < "$file"

    foreman start
}

function sync () {
    Q1="CREATE DATABASE IF NOT EXISTS bpm;"

    cd $REPO_NAME
    execute "source venv/bin/activate" "Activating virtual environment"

    cd $REPO_NAME
    execute "mysql -uroot --password='' -e $Q1" "Preparing MySQL database"
    execute "./manage.py syncdb --noinput" "Syncronizing database"
}

function update () {
    cd $REPO_NAME
    source venv/bin/activate

    cd $REPO_NAME

    # CHECK DEPENDENCIES TO DO AS IN INSTALL
    execute "sh ./system-dependencies.sh" "Updating base platform dependencies"    

    execute "pip install -r requirements.txt" "Updating python dependencies"

    # CHECK PULL BRANCH
    execute "git pull origin automator" "Updating source code"

    execute "wget --output-document .env $AWS_URL" "Downloading environment"

    execute "python manage.py collectstatic --noinput" "Updating static files cache"
    
}

###############################################################################

###############################################################################
### MAIN EXECUTION ############################################################
###############################################################################

while getopts "hvcirsu" OPTION; do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        v)
            VERBOSE=1
            ;;
        c)
            CLONE=1
            ;;
        i)
            INSTALL=1
            ;;
        r)
            RUN=1
            ;;
        s)
            SYNC=1
            ;;
        u)
            UPDATE=1
            ;;
        ?)
            echo "Invalid option: -$OPTION" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -$OPTION requires an argument." >&2
            exit 1
            ;;
    esac
done

source config.sh

if [[ $CLONE -eq 1 ]]; then
        clone
fi

if [[ $INSTALL -eq 1 ]]; then
        install
fi

if [[ $RUN -eq 1 ]]; then
        run
fi

if [[ $SYNC -eq 1 ]]; then
        sync
fi