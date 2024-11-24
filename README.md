# Terraform Installation Guide

This guide provides step-by-step instructions for installing Terraform on **Ubuntu** and **Windows** systems.

---

## Installation on Ubuntu

### Step 1: Add the HashiCorp GPG Key
Run the following command to add the HashiCorp GPG key to your system:
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### Step 2: Add the HashiCorp Repository
Add the HashiCorp repository to your system’s list of APT sources:


```bash 
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```


### Step 3: Update and Install Terraform
Update the package list and install Terraform:



```bash
sudo apt update && sudo apt install terraform
```

### Step 4: Confirm Installation
Verify the installed Terraform version:

```bash
terraform --version
```


## Installation on Windows 

#### Method 1: Manual Installation

### 1. Download the Terraform Binary
Visit the official Terraform installation page and download the appropriate binary for Windows.

### 2. Extract the File
Extract the downloaded .zip file to a location on your system (e.g., C:\Users\<YourUsername>\Downloads).

### 3. Create a Terraform Folder for System-Wide Access

Create a folder in C:\Program Files:

```bash
C:\Program Files\Terraform
```


### 4. Move the Terraform Binary

Move the extracted terraform.exe file to the newly created folder:

```bash
C:\Program Files\Terraform\terraform.exe
```


### 5. Add Terraform to the System Path

#### Open System Properties:
Press Win + S, type Environment Variables, and click Edit the system environment variables.

    In the System Properties window, click Environment Variables.
Under System variables, find and select the Path variable, then click Edit.
Click New and add the path to the directory where terraform.exe is located (e.g., C:\Program Files\Terraform).

Click OK to save changes.

Close and reopen your command prompt to apply the changes.


### 6. Verify Installation
Open a new command prompt and check the Terraform version:


```bash
terraform --version
```




# Method 2: Using Chocolatey (Preferred for Easier Updates)

### 1. Install Chocolatey

If you don't already have Chocolatey installed, open PowerShell as an administrator and run:


```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 2. Install Terraform
Use Chocolatey to install Terraform:

```powershell
choco install terraform
```

### 3. Verify Installation
Check the installed Terraform version:


### 4. Update Terraform
To update Terraform using Chocolatey, run:

```powershell
choco upgrade terraform
```


#

# Notes
Updating Terraform on Ubuntu: Run the following command to update Terraform:

```bash
sudo apt update && sudo apt install --only-upgrade terraform
```

### Uninstallation on Windows:
If installed via Chocolatey, you can uninstall Terraform with:

```powershell
choco uninstall terraform
```



Happy Terraforming! 🎉 