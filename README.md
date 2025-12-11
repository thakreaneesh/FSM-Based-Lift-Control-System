# FSM-Based Lift Control System (Nexys Artix-7 FPGA)

## Overview
This project implements a simple **Finite State Machine (FSM)** based lift control system on the Nexys Artix-7 FPGA using Verilog.  
The system controls lift movement across floors using IR sensors and a DC motor, with automatic reset functionality and real-time hardware testing.

---

## Features

### Lift Control FSM
- Controls lift movement between floors  
- Handles floor selection and direction control  
- Automatically resets the lift to the bottom floor on startup  

### Hardware Integration
- IR sensors for floor detection  
- LEDs for floor indication  
- 12V DC motor controlled through the **L293D** motor driver  
- All signals mapped and tested on the **Nexys A7 FPGA**  

### Testing & Verification
- Verified FSM logic using **Vivado testbenches**  
- Successfully tested lift movement and response to floor calls on real hardware  

---
