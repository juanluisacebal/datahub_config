# datahub_config

Configuración y scripts para levantar [DataHub](https://datahubproject.io/) en local con `datahub docker quickstart` y hacer copias de seguridad de su base de datos.

## Contenido

| Ruta | Qué es |
|------|--------|
| `quickstart/docker-compose.yml` | Compose de DataHub (Kafka, Zookeeper, MySQL, Elasticsearch, GMS, frontend…) usado por el quickstart. |
| `quickstart/quickstart_version_mapping.yaml` | Mapa de versiones del quickstart (`default`, `stable`, `head`…). |
| `quickstart/start_datahub.sh` | Arranca DataHub con el compose anterior (puertos de MySQL y Zookeeper remapeados, `ARCH=arm64`). |
| `backup.sh` | Hace un backup con `datahub docker quickstart --backup`, lo guarda en `$RUTA_BACKUP_DATAHUB/datahub_backup/<AAAA_MM>/` y lo trocea en partes de 50 MB. Con `--menu` permite elegir un backup y reconstruirlo. |
| `precommit.sh` | Carga `~/.bashrc` y lanza `backup.sh` (pensado para ejecutarse antes de cada commit). |
| `datahub_backup/` | Submódulo [datahub_backup](https://github.com/juanluisacebal/datahub_backup) con los backups troceados. |
| `docker-compose.yml` | Compose aparte de Dataiku DSS (puerto 11000). |
| `telemetry-config.json` | Configuración de telemetría del CLI de DataHub. |

## Uso

```bash
git clone --recurse-submodules https://github.com/juanluisacebal/datahub_config.git ~/.datahub
export RUTA_BACKUP_DATAHUB="$HOME/.datahub"   # opcional, es el valor por defecto
./quickstart/start_datahub.sh                 # arrancar DataHub
./backup.sh                                   # crear un backup
./backup.sh --menu                            # elegir y reconstruir un backup
```

Para reconstruir un backup a mano:

```bash
cat backup_datahub_<timestamp>.sql_part_* > backup_datahub_<timestamp>.sql
```
