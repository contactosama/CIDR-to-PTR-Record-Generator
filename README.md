# CIDR-to-PTR-Record-Generator

A simple PowerShell script that generates PTR (reverse DNS) records for an IPv4 CIDR IP pool.
The script asks for an IP pool in CIDR notation, calculates the complete IP range, and generates a text file containing PTR records that can be used when configuring reverse DNS zones.

## Features
* Accepts any IPv4 CIDR network.
* Automatically calculates:
  * Network address
  * Broadcast address
  * Total number of IP addresses
* Generates a PTR record for every IP in the CIDR range.
* Saves the generated records to the user's `Downloads` folder.
* Uses the following hostname format:

corp-khi-<last-octet>-<third-octet>.abc.com.

## Requirements
* Windows
* PowerShell 5.1 or PowerShell 7+
* Permission to write to the user's `Downloads` folder
No additional PowerShell modules are required.

## Files
The main script is:
PTR-Records.ps1
The generated output file is:
Downloads\PTR-Records.txt
