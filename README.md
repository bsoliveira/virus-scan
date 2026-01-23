# virus-scan

Simple **ClamAV (`clamscan`)** wrapper for desktop antivirus scanning.

Moves infected files to quarantine and logs only detections.

## Requirements

- ClamAV (`clamscan`)

```bash
sudo apt install clamav
sudo freshclam
```


## Usage

```bash
virus-scan <file|directory>
```

## Thunar integration

Example custom action:

```bash
alacritty -e virus-scan %f
```
The terminal stays open until a key is pressed, allowing you to read
the full clamscan output.