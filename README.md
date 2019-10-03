# sgx-genome-variants-search-simulator
## From Docker container
### Compile inside the container
Open the container:
``` bash
docker run -ti -v <external_dir>:/external ndokmai/skses:v1.0
```
where `<external_dir>` is the absolute path to the directory containing all the input files. 

Once inside the docker container:
```bash
git clone https://github.com/ndokmai/sgx-genome-variants-search.git && make
```
Inside the container, the input files can be found at `/external/`.

### Compile outside the container
Clone the SkSES repo locally:
```bash
git clone https://github.com/ndokmai/sgx-genome-variants-search.git
```
Then open the container:
``` bash
docker run -ti -v <repo_dir>:/repo -v <external_dir>:/external ndokmai/skses:v1.0
```
where `<repo_dir>` is the absolute path to the cloned repo, and `<external_dir>` is the absolute path to the directory containing all the input files. 

Once inside the container:
```bash
make PROJECT_DIR=/repo
```

Inside the container, the repo can be found at `/repo` and the input files at `/external/`.

## Build docker container locally (not recommended)
``` bash
docker build -t <tag> .
```
