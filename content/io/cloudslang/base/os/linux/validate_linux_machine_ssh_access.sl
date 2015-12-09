#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a noop SSH command.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port - Default: '22'
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - character_set - optional - character encoding used for input stream encoding from target machine
#                              - Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete - Default: '30000000'
#   - close_session - optional - if 'false' the SSH session will be cached for future calls of this operation during the
#                                life of the flow, if 'true' the SSH session used by this operation will be closed
#                              - Valid: true, false - Default: false
#   - agent_forwarding - optional - the sessionObject that holds the connection if the close session is false
# Outputs:
#   - response - Linux welcome message
#   - error_message
# Results:
#   - SUCCESS - the command execution finished successfully
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.os.linux

operation:
  name: validate_linux_machine_ssh_access
  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - privateKeyFile:
        default: str(get("private_key_file", ""))
        overridable: false
    - command:
        default: ':'
        overridable: false
    - arguments:
        required: false
    - character_set:
        required: false
    - characterSet:
        default: str(get("character_set", "UTF-8"))
        overridable: false
    - pty: 'false'
    - timeout: '30000000'
    - close_session:
        required: false
    - closeSession:
        default: str(get("close_session", "false"))
        overridable: false
    - agent_forwarding:
        required: false
    - agentForwarding:
        default: str(get("agent_forwarding", ""))
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - return_result: ${ get('returnResult', '') }
    - return_code: ${ returnCode }
    - standard_out: ${ get('STDOUT', '') }
    - standard_err: ${ get('STDERR', '') }
    - exception: ${ get('exception', '') }
    - exit_status: ${ get('exitStatus', '') }
  results:
    - SUCCESS : ${ returnCode == '0' and (not 'Error' in STDERR) }
    - FAILURE