# ansible-role-common

This is a Proof of Concept role for a contrived service, created purely for demonstration to the Sydney Ansible Meetup group.

## Test

To test the role in a vagrant-environment

```
$ make clean 
$ make create
$ make prepare
$ make converge
$ make test
```

or use the short-hand approach:

```
$ make clean setup test
```
