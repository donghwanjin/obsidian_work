---
type: note
---

#### General purpose commands

| **Command** | **Definition**        | **Usage**                                                                            |
| ----------- | --------------------- | ------------------------------------------------------------------------------------ |
| '^XA'       | Opening tag           | Used to open the ZPL data stream                                                     |
| ~JP         | Cancel and pause      | Clear the printer buffer and pause the printer (like when the cancel button is hold) |
| ~JR         | Power On Reset        | Restart the printer                                                                  |
| ~JU         | Configuration update  | Sets the printer configuration (reload the default one, save the current one..)      |
| ^PH ~PH     | Slew to Home Position | Feed a blank label                                                                   |
| ^PP ~PP     | Printer pause         | Set the printer in pause                                                             |
| ~PS         | Printer start         | Unpause the printer                                                                  |
| '^XZ'       | Closing tag           | Used to close the ZPL data stream                                                    |

#### Commands for troubleshooting purpose

| **Command**                                                                                   | **Definition**                  | **Usage**                                                                                    |
| --------------------------------------------------------------------------------------------- | ------------------------------- | -------------------------------------------------------------------------------------------- |
| ~JA                                                                                           | Cancel all                      | Clean the printer buffer                                                                     |
| ~JC                                                                                           | Media sensor calibration        | Run a short calibration                                                                      |
| ~JD                                                                                           | Enter in dump mode              | Enable Communications Diagnostics                                                            |
| ~JE                                                                                           | Return in normal mode           | Disable Communications Diagnostics                                                           |
| ~JG                                                                                           | Graphic sensor calibration      | Print the profile sensor which shows if the sensor is detecting the gap\black mark           |
| ~JL                                                                                           | Set Label Length                | The printer feeds one or more blank labels depending on the size of the label                |
| ~HB                                                                                           | Battery status                  | Returns a report about the battery status (only for mobile printers)                         |
| ~HD                                                                                           | Head status                     | Returns a report about the printhead status                                                  |
| [**^HH**](https://www.thezcorner.com/printers/languages/zpl/printers-zpl-language-hh-command) | Return configuration            | Returns the configuration label in the communication terminal                                |
| ~HI                                                                                           | Host Identification             | Return printer model and resolution, firmware version, memory size and tool options (if any) |
| ~HQ                                                                                           | Host query                      | Command group which returns multiple information about the printer status                    |
| ~HS                                                                                           | Host status return              | Returns a report with many information about the printer status                              |
| '^HV'                                                                                         | Host Verification               | Returns data from specified fields to the host computer                                      |
| '^HZ'                                                                                         | Display Description Information | Returns several type of information in XML format                                            |
| ~RO                                                                                           | Reset advanced counters         | Reset the counters related to the amount of paper printed                                    |
| '^WC'                                                                                         | Configuration label             | Print the configuration label                                                                |
| ~WL                                                                                           | Network configuration label     | Print the network configuration label                                                        |

#### Printer configuration commands

| **Command** | **Definition**                 | **Usage**                                                                                                |
| ----------- | ------------------------------ | -------------------------------------------------------------------------------------------------------- |
| '^KP'       | Define password                | Set a password to protect the configuration from unwanted canges                                         |
| '^MF'       | Media feed                     | Set the action of the printer at the start up and when the printhead (or the lid) is closed              |
| '^MM'       | Print mode                     | Set the operation mode (tear off, cutter, peeler…)                                                       |
| '^MN'       | Media tracking                 | Set the type of media in use (continous, web sensing or mark sensing)                                    |
| '^MT'       | Media type                     | Set the type of media (direct thermal or thermal transfer)                                               |
| '^MP'       | Mode Protection                | Disable buttons or functions on the printer control panel                                                |
| '^ND'       | Wired network configuration    | Set the wired network configuration                                                                      |
| ~JK         | Delayed cut                    | When the print mode is in “Delayed cut”, the printer will perform a cut when the ~JK command is received |
| '^JS'       | Sensor select                  | Set the label sensor (auto, reflective or transmissive)                                                  |
| ~JS         | Backfeed sequence              | Changes the backfeed sequence                                                                            |
| '^JZ'       | Reprint after error            | Last label is reprinted in case of paper\ribbon out or head open error                                   |
| '^KL'       | Printer language               | Select the LCD printer language                                                                          |
| '^KN'       | Printer name                   | Change the network printer name and description                                                          |
| '^SC'       | Set serial communication       | Configure the printer serial port                                                                        |
| '^ST'       | Set Real time clock            | Configure the printer clock (date and time)                                                              |
| ~TA         | Tear off adjustment            | Changes the vertical position where the label will stop after the print                                  |
| '^WI'       | Wireless network configuration | Set the wireless network configuration                                                                   |
| '^XB'       | Suppress Backfeed              | No backfeed to increase the throughput in Tear off and Rewind mode and prevent jam in Cut mode           |

#### Printer alert configuration commands

| **Command** | **Definition**                      | **Usage**                                                            |
| ----------- | ----------------------------------- | -------------------------------------------------------------------- |
| ~HU         | Return ZebraNet Alert Configuration | Returns the table of configured ZebraNet Alert settings to the host  |
| '^MA'       | Set maintenance alerts              | Controls how the printer issues printed maintenance alerts           |
| '^MI'       | Set maintenance message             | Set the content of the alert messages activated with the ^MA command |
| '^SQ'       | Halt ZebraNet Alert                 | Stop the ZebraNet Alert option                                       |
| '^SX'       | Set ZebraNet Alert                  | Configure the ZebraNet Alert System                                  |

#### Label configuration commands

| **Command** | **Definition**    | **Usage**                                                           |
| ----------- | ----------------- | ------------------------------------------------------------------- |
| '^LH'       | Label home        | Moves the origin of the x and y axis to different position.         |
| '^LL'       | Label length      | Set the label length expressed in dots                              |
| '^LS'       | Label shift       | Moves horizontally all the fields on the label                      |
| '^LT'       | Label top         | Moves vertically all the fields on the label                        |
| '^MD'       | Media darkness    | Adjusts the darkness relative to the current darkness value         |
| '^PM'       | Printing mirror   | Set the horizontal label orientation (normal or from left to right) |
| '^PO'       | Print orientation | Set the vertical label orientation (normal or upside down)          |
| '^PQ'       | Print quantity    | Set the quantity of label to print                                  |
| '^PR'       | Print rate        | Set the printing and media feeding speed                            |
| '^PW'       | Print width       | Set the labe width expressed in dots                                |
| ~SD         | Set darkness      | Set the printhead temperature                                       |

#### Files handling commands

| **Command** | **Definition**        | **Usage**                                                                                  |
| ----------- | --------------------- | ------------------------------------------------------------------------------------------ |
| '^DF'       | Store format          | Store on the printer memory a .zpl file which contains a label template                    |
| '^DG'       | Store graphic         | Store on the printer memory a graphic file                                                 |
| '^HF'       | Host format           | Returns the content of a format file stored on the printer memory                          |
| '^HG'       | Host graphic          | Returns the content of a graphic file stored on the printer memory                         |
| '^HW'       | Directory list        | Returns the list of files in a drive (similar to dir command in DOS)                       |
| '^ID'       | Object delete         | Delete a file (any type) on the printer memory                                             |
| '^TO'       | Transfer object       | Copy a file from a printer memory to another printer memory                                |
| '^WD'       | Print directory label | Similar to the ^HW command but the results are printed                                     |
| '^XF'       | Recall format         | Recall in a label a .zpl file stored on the printer memory which contains a label template |
| '^XG'       | Recall graphic        | Recall in a label a graphic file stored on the printer memory                              |

#### Label design related commands

| **Command** | **Definition**                     | **Usage**                                                                                                           |
| ----------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| '^CI'       | Change International Font/Encoding | Used to define the international character set you want to use for printing                                         |
| '^CW'       | Font Identifier                    | Assigns a single alphanumeric character to a font stored in the printer memory                                      |
| '^FB'       | Field block                        | Defines the size of a block of text which allows the word wrapping. Better for small fields                         |
| '^FC'       | Field clock                        | Used to set the clock delimiters and the clock mode for use with the real time clock                                |
| '^FD'       | Field Data                         | Create a data field                                                                                                 |
| '^FE'       | Field Concatenation                | Concatenate and substring extraction from ^FN fields                                                                |
| '^FH'       | Field hexadecimal indicator        | Allows to use the hexadecimal value for any character into the following ^FD field                                  |
| '^FN'       | Field number                       | Assign and recall a variable field. Used when a template is stored and recalled                                     |
| '^FO'       | Field origin                       | Determines the top-left origin of a field                                                                           |
| '^FP'       | Field parameter                    | Allows vertical and reverse formatting of the text field                                                            |
| '^FS'       | Field separator                    | Defines the end of a field                                                                                          |
| '^FT'       | Field typeset                      | Sets the field position (like ^FO), but can be used to concatenate other fields                                     |
| '^FW'       | Field orientation                  | Set the field orientation (normal or rotated of 90°,180° or 270°)                                                   |
| '^FX'       | Comment field                      | Used to add a comment, must be closed with a ^FS command                                                            |
| '^GB'       | Graphic box                        | Generates lines and boxes on the label                                                                              |
| '^GC'       | Graphic circle                     | Generates circles on the label                                                                                      |
| '^GD'       | Graphic Diagonal Line              | Generates a diagonal line on the label                                                                              |
| '^GE'       | Graphic ellipse                    | Generate an ellipse on the label                                                                                    |
| '^GS'       | Graphic Symbol                     | Generate the registered trademark, copyright symbol, and other symbols                                              |
| '^SF'       | Serialization Field                | Used to serialize a standard ^FD string                                                                             |
| '^SN'       | Serialization data                 | Generates a field whose value is increased or decreased each time a label is printed                                |
| '^TB'       | Text block                         | Generate a text block with defined width and height which support the word wrapping. Better with complex text field |