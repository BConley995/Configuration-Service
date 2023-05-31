# BCD Config Service 1.0

BCD Config Service 1.0 is a PowerShell script that implements a Windows form for a device configuration utility. It provides a graphical interface for performing various configuration tasks on a device.

## Features

- Install Emissary
- Set Computer Name
- Format Subordinate Disk (Y:\bcdBACKup)
- Set BCD Name
- Collect Cross Check Data

## Getting Started

To get started with BCD Config Service 1.0, follow these steps:

1. Clone the repository or download the script file.
2. Run the script using PowerShell.
3. The script will launch a graphical interface where you can select the desired configuration options.
4. Enter the required information and click "Continue" to start the configuration process.
5. Follow the on-screen instructions and monitor the progress.
6. Once the configuration is completed, a summary window will be displayed.

Please note that this script requires PowerShell to be installed on your system. Make sure you have the necessary permissions to perform the configuration tasks.

### Prerequisites

- Windows operating system
- PowerShell

### Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/your-username/bcd-config-service.git
   ```

2. Open the repository folder:

   ```shell
   cd bcd-config-service
   ```

3. Run the script:

   ```shell
   powershell.exe -ExecutionPolicy Bypass -File BCD_Config_Service.ps1
   ```

## Usage

1. Launch the BCD Config Service by running the script as mentioned in the Installation section.

2. Enter the full unit name in the provided text box.

3. Click the "Confirm" button to proceed.

4. Select the desired configuration options by checking the corresponding checkboxes.

5. Click the "Continue" button to start the configuration process.

6. A progress bar will appear, indicating the progress of the selected configuration options.

7. Once the configuration is completed, an installation completion window will be displayed, showing the collected information (if selected).

8. The "Copy to Clipboard" button can be used to copy the collected information to the clipboard.

9. The "File Cleanup" button can be used to perform file cleanup after the configuration process.

## Contributing

Contributions to the BCD Config Service 1.0 project are welcome. Here are a few ways you can contribute:

- Report bugs or suggest features by opening an issue.
- Fork the repository, make changes, and submit a pull request.
- Improve documentation by fixing errors or adding explanations.

## License

This project is licensed under the [MIT License](LICENSE).
