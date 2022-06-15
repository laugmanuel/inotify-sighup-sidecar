# inotify-sighup-sidecar

The sole purpose of this image is to watch a given file for changes and then send SIGHUP to a given process name.

You can use this image as a sidecar for Vault to notify the process whenever the certificate changes / gets renewed.

## Usage

Just deploy the image as a sidecar and make sure to enable a shared process namespace so the image can see the target process:

```yaml
- image: "laugmanuel/inotify-sighup-sidecar"
  name: inotify-sighup-sidecar
  volumeMounts:
    - name: k8s-secret-with-file-to-watch
      mountPath: /inotifywait/
```

## Configuration

The behaviour of this image is controlled by environment variables:

#### `WATCH_FILE`

Path to file the image should watch.
*Default*: `/inotifywait/tls.crt`

#### `INOTIFYWAIT_OPTS`

Options to pass to the `inotifywait` tool
*Default*: `-e modify -e delete -e delete_self`

#### `PROCESS_NAME`

Process name where the SIGHUP should be sent to:
*Default*: `vault`
