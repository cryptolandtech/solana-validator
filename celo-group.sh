GROUP
-----
celocli lockedgold:unlock --from $CELO_VALIDATOR_GROUP_ADDRESS --value 10000000000000000000000
celocli lockedgold:withdraw --from $CELO_VALIDATOR_GROUP_ADDRESS --value 10000000000000000000000
celocli validator:affiliate $CELO_VALIDATOR_GROUP_ADDRESS --from $CELO_VALIDATOR_ADDRESS

DOKIA
-----
celocli lockedgold:unlock --from $CELO_VALIDATOR_ADDRESS --value 10000000000000000000000
celocli lockedgold:withdraw --from $CELO_VALIDATOR_ADDRESS --value 10000000000000000000000










celocli lockedgold:lock --from <NEW_VALIDATOR> --value 10000000000000000000000

celocli transfer:gold --from $CELO_VALIDATOR_GROUP_ADDRESS --to=<NEW_VALIDATOR> --value 10000000000000000000000


VALIDATOR
-----
celocli lockedgold:unlock --from $CELO_VALIDATOR_ADDRESS --value 10000000000000000000000
celocli lockedgold:withdraw --from $CELO_VALIDATOR_ADDRESS --value 10000000000000000000000

