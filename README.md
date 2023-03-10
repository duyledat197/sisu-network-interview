# README file for running a Bash program

This README file provides instructions for running a Bash program.

## Prerequisites

Before running the Bash program, you need to ensure that the following prerequisites are met:

- A Bash shell is installed on your system and the version is greater than 4.0.
- The following libraries are installed:
  - coreutils
- The program file has execute permission. If not, you can give it permission using the following command:
```
chmod +x ./cmd/main.sh
```

## Running the Program

To run the Bash program, follow these steps:

1. Open a terminal window.
2. Navigate to the directory where the program file is located using the `cd` command.
3. Type the name of the program file and press Enter.

```
bash -x ./cmd/main.sh 2> out.log
```

4. The program will start running and display output on the terminal.

## Program Output

The program output will be displayed on the terminal window. If the program generates an output file, it will be saved in the same directory as the program file.

## Conclusion

Following these steps will allow you to run the Bash program and see its output. If you encounter any issues or errors, check that you have met all the prerequisites and try again.
