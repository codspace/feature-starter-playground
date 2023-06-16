#!/bin/bash

# The duplicate test mode is used to assert that a Feature can be installed multiple times and behaves as expected.
#
# - This test mode will look for a 'duplicate.sh' file in the tatget Feature's test directory.
# - This test mode is skipped if the '--skip-duplicated' flag is passed when running the test.
# - The '--permit-randomization' flag will change whether the auto-generated config contains predictiable or randomized option values.
# 
# In this mode, a dev container will be generated similar to below:
# {
#     "image": "ubuntu",
#     "features": {
#         "./color": {
#             "favorite": "green", // Non-default option values from the proposals/enum in Feature 'devcontainer-feature.json'
#         },
#         "./color-0": {} // Default
#     }
# }
# If the container succeeds to build, this script will be executed.
# There are some additional environment variables injected to make writing assertions easier
# - <OPTION_NAME> - The value of the non-default option from the config. (e.g. in this case FAVORITE='green')
# - <OPTION_NAME>__DEFAULT - The value of the default option from the config. (e.g. in this case FAVORITE__DEFAULT='red')

set -e

# Optional: Import test library
source dev-container-features-test-lib

# The values of the randomized options will be set as environment variables.
if [ -z "${FAVORITE}" ]; then
	echo "Favorite color from randomized Feature not set!"
	exit 1
fi

# The values of the default options will be set as environment variables.
if [ -z "${FAVORITE__DEFAULT}" ]; then
	echo "Favorite color from default Feature not set!"
	exit 1
fi

# Definition specific tests
check "runColorCmd" color

# Definition test specific to what option was set.
check "Feature with randomized options installed correctly" color-"${FAVORITE}"

# Definition test specific to what option was set.
check "Feature with default options installed correctly" color-"${FAVORITE__DEFAULT}"

# Report result
reportResults