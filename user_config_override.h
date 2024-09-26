/*
  user_config_override.h - user configuration overrides my_user_config.h for Tasmota

  Copyright (C) 2021  Theo Arends

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _USER_CONFIG_OVERRIDE_H_
#define _USER_CONFIG_OVERRIDE_H_

/*****************************************************************************************************\
 * USAGE:
 *   To modify the stock configuration without changing the my_user_config.h file:
 *   (1) copy this file to "user_config_override.h" (It will be ignored by Git)
 *   (2) define your own settings below
 *
 ******************************************************************************************************
 * ATTENTION:
 *   - Changes to SECTION1 PARAMETER defines will only override flash settings if you change define CFG_HOLDER.
 *   - Expect compiler warnings when no ifdef/undef/endif sequence is used.
 *   - You still need to update my_user_config.h for major define USE_MQTT_TLS.
 *   - All parameters can be persistent changed online using commands via MQTT, WebConsole or Serial.
\*****************************************************************************************************/

/*
Examples :

// -- Master parameter control --------------------
#undef  CFG_HOLDER
#define CFG_HOLDER        4617                   // [Reset 1] Change this value to load SECTION1 configuration parameters to flash

// -- Setup your own Wifi settings  ---------------
#undef  STA_SSID1
#define STA_SSID1         "YourSSID"             // [Ssid1] Wifi SSID

#undef  STA_PASS1
#define STA_PASS1         "YourWifiPassword"     // [Password1] Wifi password

// -- Setup your own MQTT settings  ---------------
#undef  MQTT_HOST
#define MQTT_HOST         "your-mqtt-server.com" // [MqttHost]

#undef  MQTT_PORT
#define MQTT_PORT         1883                   // [MqttPort] MQTT port (10123 on CloudMQTT)

#undef  MQTT_USER
#define MQTT_USER         "YourMqttUser"         // [MqttUser] Optional user

#undef  MQTT_PASS
#define MQTT_PASS         "YourMqttPass"         // [MqttPassword] Optional password

// You might even pass some parameters from the command line ----------------------------
// Ie:  export PLATFORMIO_BUILD_FLAGS='-DUSE_CONFIG_OVERRIDE -DMY_IP="192.168.1.99" -DMY_GW="192.168.1.1" -DMY_DNS="192.168.1.1"'

#ifdef MY_IP
#undef  WIFI_IP_ADDRESS
#define WIFI_IP_ADDRESS     MY_IP                // Set to 0.0.0.0 for using DHCP or enter a static IP address
#endif

#ifdef MY_GW
#undef  WIFI_GATEWAY
#define WIFI_GATEWAY        MY_GW                // if not using DHCP set Gateway IP address
#endif

#ifdef MY_DNS
#undef  WIFI_DNS
#define WIFI_DNS            MY_DNS               // If not using DHCP set DNS IP address (might be equal to WIFI_GATEWAY)
#endif

#ifdef MY_DNS2
#undef  WIFI_DNS2
#define WIFI_DNS2           MY_DNS2              // If not using DHCP set DNS IP address (might be equal to WIFI_GATEWAY)
#endif

// !!! Remember that your changes GOES AT THE BOTTOM OF THIS FILE right before the last #endif !!!
*/





#endif  // _USER_CONFIG_OVERRIDE_H_
#ifdef ESP32
   #undef ESP32
#endif
#define ESP32
#ifdef USE_RULES
  #undef USE_RULES
#endif
#define USE_RULES

#ifdef USE_I2S_ALL
  #undef USE_I2S_ALL
#endif

#define USE_I2S_ALL
#ifdef I2S_BRIDGE
  #undef I2S_BRIDGE
#endif
#define I2S_BRIDGE
#ifdef USE_I2S_AUDIO
  #undef USE_I2S_AUDIO
#endif
#define USE_I2S_AUDIO
#ifdef USE_I2S_LSB
  #undef USE_I2S_LSB
#endif
#define USE_I2S_LSB
#ifdef USE_I2S_SAY
  #undef USE_I2S_SAY
#endif
#define USE_I2S_SAY
#ifdef USE_I2S_SAY_TIME
  #undef USE_I2S_SAY_TIME
#endif
#define USE_I2S_SAY_TIME
#ifdef USE_I2S_WEBRADIO
  #undef USE_I2S_WEBRADIO
#endif
#define USE_I2S_WEBRADIO
#ifdef USE_I2S_RTTTL
  #undef USE_I2S_RTTTL
#endif
#define USE_I2S_RTTTL
#ifdef USE_MATTER_DEVICE
  #undef USE_MATTER_DEVICE
#endif
#define USE_MATTER_DEVICE
#ifdef USE_UFILESYS
  #undef USE_UFILESYS
#endif
#define USE_UFILESYS
#ifdef USE_BUZZER
  #undef USE_BUZZER
#endif
#define USE_BUZZER
#ifdef USE_WS2812
  #undef USE_WS2812
#endif
#define USE_WS2812
#ifdef I2S_MP3
  #undef I2S_MP3
#endif
#define I2S_MP3
#ifdef USE_SHINE
  #undef USE_SHINE
#endif
#define USE_SHINE
#ifdef MP3_MIC_STREAM
  #undef MP3_MIC_STREAM
#endif
#define MP3_MIC_STREAM
#ifdef USE_I2S_MIC
  #undef USE_I2S_MIC
#endif
#define USE_I2S_MIC
#ifdef USE_SHINE
  #undef USE_SHINE
#endif
#define USE_SHINE
#ifdef USE_BERRY
  #undef USE_BERRY
#endif
#define USE_BERRY

#ifdef USE_BERRY_PSRAM
  #undef USE_BERRY_PSRAM
#endif
#define USE_BERRY_PSRAM

#ifdef USE_HOME_ASSISTANT
  #undef USE_HOME_ASSISTANT
#endif
#define USE_HOME_ASSISTANT
#ifdef USE_MATTER_DEVICE
  #undef USE_MATTER_DEVICE
#endif
#define USE_MATTER_DEVICE

#ifdef USE_BERRY_CRYPTO_EC_P256
  #undef USE_BERRY_CRYPTO_EC_P256
#endif
#define USE_BERRY_CRYPTO_EC_P256

#ifdef USE_BERRY_CRYPTO_HMAC_SHA256
  #undef USE_BERRY_CRYPTO_HMAC_SHA256
#endif
#define USE_BERRY_CRYPTO_HMAC_SHA256

#ifdef USE_BERRY_CRYPTO_HKDF_SHA256
  #undef USE_BERRY_CRYPTO_HKDF_SHA256
#endif
#define USE_BERRY_CRYPTO_HKDF_SHA256

#ifdef USE_BERRY_CRYPTO_AES_CCM
  #undef USE_BERRY_CRYPTO_AES_CCM
#endif
#define USE_BERRY_CRYPTO_AES_CCM

#ifdef USE_BERRY_CRYPTO_AES_CTR
  #undef USE_BERRY_CRYPTO_AES_CTR
#endif
#define USE_BERRY_CRYPTO_AES_CTR

#ifdef USE_BERRY_CRYPTO_PBKDF2_HMAC_SHA256
  #undef USE_BERRY_CRYPTO_PBKDF2_HMAC_SHA256
#endif
#define USE_BERRY_CRYPTO_PBKDF2_HMAC_SHA256

#ifdef USE_BERRY_CRYPTO_SPAKE2P_MATTER
  #undef USE_BERRY_CRYPTO_SPAKE2P_MATTER
#endif
#define USE_BERRY_CRYPTO_SPAKE2P_MATTER

#ifdef USE_DISCOVERY
  #undef USE_DISCOVERY
#endif
#define USE_DISCOVERY
#ifdef USE_EXPRESSION
  #undef USE_EXPRESSION
#endif
#define USE_EXPRESSION

#ifdef SUPPORT_IF_STATEMENT
  #undef SUPPORT_IF_STATEMENT
#endif
#define SUPPORT_IF_STATEMENT

#ifdef USE_SCRIPT
  #undef USE_SCRIPT
#endif

#ifdef USE_UFILESYS
  #undef USE_UFILESYS
#endif
#define USE_UFILESYS

#ifdef USE_SDCARD
  #undef USE_SDCARD
#endif
#define USE_SDCARD

#ifdef GUI_TRASH_FILE
  #undef GUI_TRASH_FILE
#endif
#define GUI_TRASH_FILE

#ifdef GUI_EDIT_FILE
  #undef GUI_EDIT_FILE
#endif
#define GUI_EDIT_FILE

#ifdef USE_WEBSERVER
  #undef USE_WEBSERVER
#endif
#define USE_WEBSERVER
#ifdef MY_LANGUAGE
  #undef MY_LANGUAGE
#endif
#define MY_LANGUAGE	en_GB



#ifdef USE_SPI
  #undef USE_SPI
#endif
#define USE_SPI

#ifdef USE_TIMERS
  #undef USE_TIMERS
#endif
#define USE_TIMERS
#ifdef USE_WEBSERVER
  #undef USE_WEBSERVER
#endif
#define USE_WEBSERVER