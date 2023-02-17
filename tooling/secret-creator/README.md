# Secret creator

If you need to provision several secrets on AWS Secret Manager, you can do it programatically with help of this script.
Since naming convention for Secrets follows /`application`/`environment`/`secret_name`, you need to specify your `secret.txt` files, please review sample on this repo.
Besides you need to specify application(`api`,`app`,`sdk`,etc) and environment (`development`,`staging` or  `production`) as second and third argument.


## Usage

`./upload-secrets.sh secrets.txt api development &>> log.txt`
