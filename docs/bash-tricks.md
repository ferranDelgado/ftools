# Scripting tricks and things that I always forget

## Directories and files

### Check folder exists with if else
```bash
if [ -d "/path/to/dir" ] 
then
    echo "Directory /path/to/dir exists." 
else
    echo "Error: Directory /path/to/dir does not exists."
fi
```

### Create folder if it doesn't exists

```bash
[ ! -d $versions_folder ] && mkdir -p $versions_folder
``` 

## Read arguments
### Value or error
```bash
NAME=${1?Error: no name given}
```

### Value or defaul
```bash
NAME=${2:-friend}
```

### Check #arguments
```bash
if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters"
    exit 2
fi
```

### [How do I parse command line arguments in bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)

### Switch on arguments
```bash
  case $1 in
    connect)
        echo "Connect to $2 ($id)"
        ;;
    ip)
        echo "Ip of container $2"
        ;;
    *) 
      echo "Error: unknown argument $1"
      help
      ;;
  esac
```

### Switch on arguments loop
```bash
for param in "$@" 
do
    case $param in
        --full-name | --full | -f)
            fullname=true
            ;;
        --quiet | -q)
            quiet=true
            ;;
        *)
            input=$param
            ;;
    esac
done
```

## Read and wait for user input
```bash
read varname
echo It\'s nice to meet you $varname
```
