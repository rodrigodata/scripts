# check if pamac is installed
echo "Checking if PAMAC is installed.."

if ! [ -x "$(command -v pamac)" ]; 
then
  echo 'I did not find the package pamac on your computer. Installing..'
  sudo pacman -S pamac-cli --noconfirm
  pamac --version
fi

echo "Installing latest version of docker.."
pamac install docker --no-confirm

echo "Setting up configuration for docker.."
sudo systemctl start docker.service
sudo systemctl enable docker.service
docker --version