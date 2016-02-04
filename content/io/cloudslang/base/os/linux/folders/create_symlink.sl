# (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs SSH command to create a symbolic link between <source_folder> and <linked_folder>
#
# Inputs:
#   - host - hostname or IP address
#   - root_password - the root password
#   - source_folder - the name of the folder to be linked
#   - linked_folder - the name of the linked folder
#
# Outputs:
#   - return_result - STDOUT of the remote machine in case of success or the cause of the error in case of exception
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - exception - contains the stack trace in case of an exception
#   - command_return_code - The return code of the remote command corresponding to the SSH channel. The return code is
#                           only available for certain types of channels, and only after the channel was closed
#                           (more exactly, just before the channel is closed).
#	                        Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#                                     channel type has no command), 126 if the command cannot execute.
# Results:
#    - SUCCESS - SSH access was successful
#    - FAILURE - otherwise
####################################################
namespace: io.cloudslang.base.os.linux.folders

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: create_symlink

  inputs:
    - host
    - root_password
    - source_folder
    - linked_folder

  workflow:
    - create_symlink:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - command: ${'ln -s ' + source_folder + ' ' + linked_folder}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code

  results:
    - SUCCESS: ${return_code == '0' and command_return_code == '0'}
    - FAILURE