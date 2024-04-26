## OpenR&D DAO Extensions

OpenR&D extensions for smart accounts (such as DAOs).  
Currently this includes:  
- Charging a fee (which could be 0) to let anyone create a draft proposal. (createTask)  
- Charging a fee (which could be 0) to let anyone create a dispute proposal. (completeByDispute)  

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Deploy

```shell
make deploy
```

## Local chain

```shell
anvil
make local-fund ADDRESS="YOURADDRESSHERE"
```

### Analyze

```shell
make slither
make mythril TARGET=Counter.sol
```

### Help

```shell
forge --help
anvil --help
cast --help
```
