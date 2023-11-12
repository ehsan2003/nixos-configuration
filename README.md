## My personal nixos configuration
before using this configuration you need a json file for secrets in `/etc/secrets.json`
then you can build this using :
```bash
sudo nixos-rebuild switch --flake .#nixos-home-desktop  # for home pc
sudo nixos-rebuild switch --flake .#nixos-laptop # for laptop
sudo nixos-rebuild switch --flake .#iso # for the iso file
```

there are 4 required keys in `secrets.json` file: 
- openvpn - openvpn configuration
- proxy - a shell script that runs the proxy on port 1080
- OPENAI_API_KEY - open ai's api key
- location - latitude and longitude of your current location (for praytimes and redshift)

