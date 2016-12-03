#include "mbed.h"
#include "multichannel_gas_sensor.h"

Serial pc(USBTX, USBRX);
I2C i2c(I2C_SDA, I2C_SCL);

GroveMutichannelGasSensor gas(i2c);

int main() {
    float gas_read;
    pc.baud(115200);

    pc.printf("Enter main\r\n");

    gas.begin(0x04 << 1);
    gas.powerOn();

    while (true) {
        wait(5);
        pc.printf("------------------------------\r\n");

        gas_read = gas.measure_NH3();
        pc.printf("NH3 %f ppm\r\n", gas_read);

        gas_read = gas.measure_CO();
        pc.printf("CO %f ppm\r\n", gas_read);

        gas_read = gas.measure_NO2();
        pc.printf("NO2 %f ppm\r\n", gas_read);

        gas_read = gas.measure_C3H8();
        pc.printf("C3H8 %f ppm\r\n", gas_read);

        gas_read = gas.measure_C4H10();
        pc.printf("C4H10 %f ppm\r\n", gas_read);

        gas_read = gas.measure_CH4();
        pc.printf("CH4 %f ppm\r\n", gas_read);

        gas_read = gas.measure_H2();
        pc.printf("H2 %f ppm\r\n", gas_read);

        gas_read = gas.measure_C2H5OH();
        pc.printf("C2H50H %f ppm\r\n", gas_read);
    }
}
