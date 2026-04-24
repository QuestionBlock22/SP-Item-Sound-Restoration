#!/usr/bin/python

import sys
import subprocess
import shutil
import os

from pathlib import Path
from collections import OrderedDict

pyiiasmh = "tools/pyiiasmh/pyiiasmh_cli.py"

'''
Download PyiiASMH from the releases section. Don't clone the repository.

'''

codeName = "Play Different Item Receive Sound When Receiving Special Items [Ro, QB22]"
codeDesc = "Play the special item sound from Mario Kart DS when the player receives an item with an ID greater than the Spiny Shell."

finalOut = "finalOut.txt"

errorCount = 0

def getRegion():
    regionLetter = input("Input the letters P, E, J or K for your region.\n")
    if len(regionLetter) > 1:
            print ("No more than one character can be input. Exiting.\n")
            sys.exit()
    if regionLetter == 'p' or regionLetter == 'P' or regionLetter == 'e' or regionLetter == 'E' or regionLetter == 'j' or regionLetter == 'J' or regionLetter == 'k' or regionLetter == 'K':
        return regionLetter
    else:
        print("Only input the letters, P, E, J, or K. Exiting.")
        sys.exit()

def processRegion(regionLetter):
    if regionLetter == 'p' or regionLetter == 'P':
        region = "RMCP01"
    elif regionLetter == 'e' or regionLetter == 'E':
        region = "RMCE01"
    elif regionLetter == 'j' or regionLetter == 'J':
        region = "RMCJ01"
    elif regionLetter == 'k' or regionLetter == 'k':
        region = "RMCK01"
    else:
        print ("Invalid character(s) entered.")
        sys.exit

    return region

def getBaseAddress(regionLetter):
    # C2 Base Addresses
    PlaySpecialItemSound = "80717770"
    SetSpecialItemSound = "8079814C"

    # A list of C2 hooks
    baseAddress = [
        PlaySpecialItemSound,
        SetSpecialItemSound
    ]

    list(OrderedDict.fromkeys(baseAddress))

    if regionLetter == 'p' or regionLetter == 'P':
        return baseAddress
    elif regionLetter == 'e' or regionLetter == 'E':
        baseAddress[0] = "8070fccc"
        baseAddress[1] = "8078F140"

    elif regionLetter == 'j' or regionLetter == 'J':
        baseAddress[0] = "80716ddc"
        baseAddress[1] = "807977B8"

    elif regionLetter == 'k' or regionLetter == 'K':
        baseAddress[0] = "80705b18"
        baseAddress[1] = "8078650C"

    return baseAddress

def assembleFromFile(regionLetter, curDir, addressCycle):
    baseAddress = getBaseAddress(regionLetter)

    # The current working directory is unaware that this file is needed so let's copy it.
    includeFile = "__includes.s"
    shutil.copyfile(f"tools/pyiiasmh/{includeFile}", f"{includeFile}")

    tempCode = "tmp.s"
    asmOut = "asmOut.txt"

    for file in sorted(Path(curDir).rglob('*.s')):
        codeFile = f"{curDir}/{file.name}"

        with open(codeFile, 'r') as code, open(tempCode, 'w') as tmp:
            tmp.write(f".set region, '{regionLetter}'\n\n")
            for line in code:
                tmp.write(line)

        print(baseAddress[addressCycle])
        print(file.name)

        subprocess.run(["python", pyiiasmh, tempCode, 'a', '--dest', asmOut, '--codetype', 'C2D2', '--bapo', f'{baseAddress[addressCycle]}'])

        with open(asmOut, 'r') as scratchAssembly, open(finalOut, 'a') as codeOutput:
            for line in scratchAssembly:
                codeOutput.write(line)
            codeOutput.write("\n")

        if addressCycle == 1:
            os.remove(includeFile)
            os.remove(tempCode)
            os.remove(asmOut)
            return

        addressCycle += 1

def assembleASMCode(regionLetter):
    curDir = "src"
    addressCycle = 0

    assembleFromFile(regionLetter, curDir, addressCycle)

def assembleCode(region, regionLetter):
    with open(f"{region}.txt", 'w') as codeOutput:
        codeOutput.write(f"{region}\n")
        codeOutput.write("Mario Kart Wii\n\n")
        codeOutput.write(f"{codeName}\n")
        assembleASMCode(regionLetter)
        with open(finalOut, 'r') as finalAssembly:
            for line in finalAssembly:
                codeOutput.write(line)
    with open(f"{region}.txt", 'a') as codeOutput:
        codeOutput.write(f"\n{codeDesc}")

def prepareAssembly():
    regionLetter = getRegion()
    region = processRegion(regionLetter)
    codeFile = Path(f"{region}.txt")
    if codeFile.is_file():
        os.remove(codeFile)
    assembleCode(region, regionLetter)
    os.remove(finalOut)

def main():
    pyiiasmh_path = Path(pyiiasmh)
    if pyiiasmh_path.is_file():
        print("System check passed.\n")
        prepareAssembly()
        print("\nOperation completed successfully.")
    else:
        print("PyiiASMH is required for this build script to function. Download PyiiASMH from 'https://github.com/JoshuaMKW/pyiiasmh' from the releases section and put it inside the tools directory.\n")
        sys.exit

main()
