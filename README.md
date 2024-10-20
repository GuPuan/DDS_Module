# Signal Generator Based on AD9767 Chip

This project is a dual-channel signal generator built using the AD9767 DAC chip. It is capable of generating various waveforms such as sine, triangle, and square waves using ROM IP. The design allows for independent control of the frequency and phase of the signals generated on both channels using push buttons. The clock frequency is increased from 50 MHz to 125 MHz using the Clock/MMCM IP. The push buttons are also equipped with a debounce mechanism for stable operation.

## Features

- **Dual-Channel Output**: The signal generator supports two separate channels, each capable of independent frequency and phase adjustments.
- **Waveform Generation**:
  - **Sine Wave**
  - **Triangle Wave**
  - **Square Wave**
  - Waveforms are generated using ROM IP with a data width of **14 bits** and a depth of **4096**.
- **Frequency Multiplication**:
  - The base clock frequency is increased from 50 MHz to 125 MHz using Clock/MMCM IP to achieve higher signal resolution.
- **Button-Controlled Frequency and Phase Adjustment**:
  - Each channel can be controlled independently using push buttons.
  - The buttons allow users to change the frequency and phase of the generated signals for each channel.
- **Debounce Functionality**:
  - All push buttons are equipped with a debounce function to ensure stable input and prevent unintentional signal changes.

## System Overview

- **AD9767 Chip**: The DAC chip responsible for converting digital signals into analog waveforms.
- **ROM IP**: Utilized for storing waveform data (sine, triangle, and square waves) with a width of **14 bits** and a depth of **4096**.
- **Clock/MMCM IP**: Used to multiply the clock frequency from 50 MHz to 125 MHz, enhancing signal quality and frequency range.
- **Button Interface**: 
  - Two sets of push buttons for each channel, used for adjusting frequency and phase settings independently.
  - Debounce circuitry is integrated for each button to avoid false triggering.

## Getting Started

1. **Hardware Setup**:
   - Connect the AD9767 chip as per the provided schematic.
   - Ensure the Clock/MMCM IP and ROM IP are properly configured in the FPGA design.
2. **Button Configuration**:
   - Connect push buttons for channel control as specified.
   - Verify the debounce logic is active for each button.
3. **Power On**:
   - Power on the system and observe the dual-channel signal outputs.
   - Use the push buttons to adjust frequency and phase settings for each channel independently.

## Notes

- Ensure that the clock and ROM IP configurations are correctly set for optimal performance.
- The debounce functionality may require fine-tuning based on the specific buttons and hardware used.
- The frequency range and phase control settings are limited by the resolution of the clock and DAC configurations.

