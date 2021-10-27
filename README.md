# cdhook
Run functions after cd to a directory. 


# feature
1. Set golang vendor to CDPATH, if `git config --get golang.cdpath` is true. 
1. Set git user name and email. 


# config
## auto set golang cdpath
### `CDHOOK_USE_SET_GOLANG_CDPATH`
default: true.   
Enable set golang vendor to CDPATH.   

## auto set git user name and email
### `CDHOOK_USE_SET_GIT_USER`
default: true.  
Enable set user name and email.  

### `CDHOOK_GET_MATCH_URL`
default: ''  
If `$CDHOOK_GET_MATCH_URL` is substr of origin remote url, it will auto run:  
```bash
git config user.name $CDHOOK_GIT_MATCH_USER
git config user.email $CDHOOK_GIT_MATCH_EMAIL
```
Else, it will auto run:
```bash
git config user.name $CDHOOK_GIT_OTHER_USER
git config user.email $CDHOOK_GIT_OTHER_EMAIL
```

### `CDHOOK_GET_MATCH_USER`
default: ''  

### `CDHOOK_GET_MATCH_EMAIL`
default: ''  

### `CDHOOK_GET_OTHER_USER`
default: ''  

### `CDHOOK_GET_OTHER_EMAIL`
default: ''  
