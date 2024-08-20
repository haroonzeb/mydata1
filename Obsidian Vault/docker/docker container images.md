### Filtering Images by Repository and Tag

If you want to filter the images to display only those with the `google/cloud-sdk:latest` tag, you can use the `--filter` option:

2. **Filter by Repository and Tag**:

   `docker images --filter=reference='google/cloud-sdk:latest'
### Combined Command

To combine the steps, you can list and delete the image in one go:

`docker rmi $(docker images --filter=reference='google/cloud-sdk:latest' -q)`

Here’s a breakdown:

- `docker images --filter=reference='google/cloud-sdk:latest' -q` lists the image IDs matching the reference filter.
- `docker rmi $(...)` removes the images whose IDs are returned by the previous command.

### Example Command and Output

`docker rmi $(docker images --filter=reference='google/cloud-sdk:latest' -q)`

**Note**: If there are running containers using the image you want to delete, you will need to stop and remove those containers first.