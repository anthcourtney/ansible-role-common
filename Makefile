clean: vagrant-destroy cleanup-roles

create: vagrant-up

prepare: requirements role-under-test syntax-check

converge: vagrant-provision

setup: create prepare converge

test: idempotency-test functional-test

# Prepare helpers

requirements:
	@ansible-galaxy install -r tests/requirements.yml -p tests/roles -f

role-under-test:
	@if [ -d tests/roles/common ]; then rm -rf tests/roles/common; fi
	@mkdir -p tests/roles/common
	@rsync -az --exclude tests . tests/roles/common/

syntax-check:
	@echo 'Running syntax-check'
	@cd tests && ansible-playbook -i localhost, --syntax-check --list-tasks site.yml \
	  && (echo 'Passed syntax-check'; exit 0) \
	  || (echo 'Failed syntax-check'; exit 1)

# Test helpers

idempotency-test:
	@echo 'Running idempotency test'
	@${MAKE} vagrant-provision | tee /tmp/ansible_$$$$.txt; \
	grep -q 'changed=0.*failed=0' /tmp/ansible_$$$$.txt \
	  && (echo 'Passed idempotency test'; exit 0) \
	  || (echo "Failed idempotency test"; exit 1)

functional-test:
	@echo 'Running functional test'
	@RUN_TESTS=true ${MAKE} vagrant-provision \
	  && (echo 'Passed functional test'; exit 0) \
	  || (echo 'Failed functional test'; exit 1)

# Cleanup helpers

cleanup-roles:
	@if [ -d tests/roles ]; then rm -rf tests/roles; fi

vagrant-destroy:
	@cd tests && vagrant destroy -f

# Create helpers
	
vagrant-up:
	@cd tests && vagrant up --no-provision

# Converge helpers

vagrant-provision:
	@cd tests && vagrant provision

# Misc helpers

vagrant-ssh:
	@cd tests && vagrant ssh
