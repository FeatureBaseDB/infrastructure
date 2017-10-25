.PHONY: create-stack update-stack delete-stack describe-stack
STACK=util-server
PARAMETERS=file://cfn-parameters.json
TEMPLATE=file://cfn.yaml

env:
	virtualenv env

create-stack: $(JSON_FILE)
	aws cloudformation create-stack --stack-name $(STACK) --template-body $(TEMPLATE) --capabilities CAPABILITY_IAM --parameters $(PARAMETERS)

update-stack: $(JSON_FILE)
	aws cloudformation update-stack --stack-name $(STACK) --template-body $(TEMPLATE) --capabilities CAPABILITY_IAM --parameters $(PARAMETERS)

delete-stack:
	aws cloudformation delete-stack --stack-name $(STACK)

describe-stack:
	aws cloudformation describe-stacks --stack-name $(STACK)
