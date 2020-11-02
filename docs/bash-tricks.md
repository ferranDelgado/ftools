# Scripting tricks and things that I always forget

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
## Read and wait for user input
```bash
read varname
echo It\'s nice to meet you $varname
```
