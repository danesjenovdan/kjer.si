#!/bin/bash

sudo docker build ./backend -t kjer.si:latest
sudo docker tag kjer.si:latest rg.fr-par.scw.cloud/djnd/kjer.si:latest
sudo docker login rg.fr-par.scw.cloud/djnd -u nologin -p $SCW_SECRET_TOKEN
sudo docker push rg.fr-par.scw.cloud/djnd/kjer.si:latest
