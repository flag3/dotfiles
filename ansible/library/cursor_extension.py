from ansible.module_utils.basic import AnsibleModule

module = AnsibleModule(argument_spec=dict(name={}))
name = module.params["name"]
rc, out, err = module.run_command(["cursor", "--list-extensions"])
installed = [line.strip() for line in out.splitlines() if line.strip()]
changed = False

if name not in installed:
    module.run_command(["cursor", "--install-extension", name])
    changed = True

module.exit_json(changed=changed)
