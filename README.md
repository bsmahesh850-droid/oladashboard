# EV DashLab — Smart Electric Scooter Dashboard + RTL Verification Studio

EV DashLab is an interactive, mobile-friendly **Electric Vehicle (EV) Dashboard** and **SystemVerilog RTL Verification Studio** designed for Electronics and Communication Engineering (ECE) hardware projects.

## Key Features
* **EV Instrument Cluster**: High-contrast, dark-mode speedometer, battery gauge, ride modes (ECO, NORMAL, SPORT), range telemetry, and turn signals.
* **Dual Simulation Engine**:
  * **Demo Mode**: Smooth JavaScript physics loop for instant visual UI testing.
  * **RTL Hardware Mode**: Import VCD logs or terminal output from external simulators (Icarus Verilog, Verilator, EDA Playground) to drive the dashboard with verified hardware signals.
* **Route & Range Planner**: Interactive OpenStreetMap (Leaflet) route visualizer with battery consumption telemetry.
* **RTL Lab**: Built-in SystemVerilog design (`ola_speed_controller.sv`) and self-checking testbench (`ola_speed_controller_tb.sv`).

## Disclaimer
This is an **educational student research project** for digital system design coursework. It is **not affiliated with, endorsed by, or connected to Ola Electric** or any commercial vehicle manufacturer.

## How to Deploy to GitHub Pages
1. Push all files to your repository on GitHub.
2. Go to **Repository Settings** -> **Pages**.
3. Under **Branch**, select `main` (or `master`) and folder `/ (root)`.
4. Click **Save**. Your site will be live in 1-2 minutes!
