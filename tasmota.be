#{"NAME":"T5-3C-86","GPIO":[0,0,7808,0,7840,3872,0,0,0,1376,0,7776,0,0,224,3232,0,480,3200,0,0,0,3840,0,0,0,0,0,0,0,0,0,0,0,0,0],"FLAG":0,"BASE":1,"CMND":"Backlog Pixels 28"}
#{"NAME":"TX Ultimate 3","GPIO":[0,0,7808,0,7840,3872,0,0,0,1376,0,7776,0,225,224,3232,0,480,3200,0,0,0,3840,226,0,0,0,0,0,0,0,0,0,0,0,0],"FLAG":0,"BASE":1,"CMND":"Backlog Pixels 28"}
#SetOption80 1
#ShutterMode 1
#ShutterRelay1 1
#Interlock 1,3
#Interlock ON

#persist.device_type = "Blinds"

import string
import animate
import persist # stored in persist: led_cnt, light_color, light_duration, light_brightness, light_animation, light_on, light_palette, light_effect, light_config_mode, device_type



class TXUltimateMode 
   
    var strip
    var anim
    var pulse
    var oscillator
    var palette

    

    var device_mode  #working mode


    def handle_action(value, trigger, msg)    
        if value == "Touch"
            if self.device_mode == "Normal"
                tasmota.cmd("Buzzer", "1")
            end
            return
        end
        #print parameters
        #print("TXU: Action =", value, "Trigger =", trigger, "Msg =", msg)
        #msg is map, get the value of the key
        var obj = msg.find("TXUltimate")  
        #print("TXU: Obj =", obj)

        var channel = obj.find("Channel")
        var from = obj.find("From")
        var to = obj.find("To")
        #print("TXU: Action =", value, "Channel =", channel, "From =", from, "To =", to)
        
        if value == "Swipe right"
            self.do_swipe_right(from, to)
            return
        end
        if value == "Swipe left"
            self.do_swipe_left(from, to)        
            return
        end
        if value == "Short"
            self.do_short(channel)        
            return
        end
        if value == "Long"
            self.do_long(channel)
            return
        end
        if value == "Multi"
            self.do_multi()
            return
        end
        if value == "Dash"
            self.do_dash(from, to)
            return
        end
    end

    def do_swipe_right(from, to)
        print("TXU: Swipe right", from, to)
    end

    def do_swipe_left(from, to)
        print("TXU: Swipe left", from, to)
    end

    def do_dash(from, to)
        var from_lane = self.calculate_lane(from)
        var to_lane = self.calculate_lane(to)
        print("TXU: Dash", from, to, from_lane, to_lane)
    
        if from_lane == to_lane
            self.do_short(from)
            return
        end
    end 
    
    def do_long(channel)
        var lane = self.calculate_lane(channel)        
        print("TXU: Long", channel,lane)
        if self.device_mode == "Normal"
            self.device_mode = "Config"
            self.speak("Configuration mode")
            return
        end
        if self.device_mode == "Config"
            self.device_mode = "Normal"
            self.speak("Exit configuration mode")
        end
    end

    def do_multi()
        print("TXU: Multi")
        if self.device_mode == "Config"
            self.device_mode = "Normal"
            self.speak("Exit configuration mode")
        
        else
            persist.light_on = 1 - int(persist.light_on)
            print("TXU: Light on", persist.light_on)
            self.restart_leds()
        end
        
    end

    def calculate_lane(channel)
        if channel <5
            return 1
        end
        if channel <8
            return 2
        end
        if channel <11
            return 3
        end
        return 4
    end

    def do_short(channel)
        var lane = self.calculate_lane(channel)
        print("TXU: Short", channel, lane)
        if self.device_mode == "Normal"
            self.do_short_normal(channel, lane)
            return
        end
        if self.device_mode == "Config"
            self.do_short_config(channel, lane)
        end
    end

    def do_short_normal(channel, lane)
        if persist.device_type == "Blinds"
            if lane == 3
                lane = 2
            else
                if lane == 2
                    lane = 3
                end
            end
        end
        var val = tasmota.get_power(lane-1)
        print("TXU: Short normal", channel, lane, val)
       

        if(val)
            tasmota.set_power(lane-1, false)
            print("TXU: Set power", lane, false)
        else
            tasmota.set_power(lane-1, true)
            print("TXU: Set power", lane, true)
        end
        
        # if self.device_type == "Light" || lane == 2
        #     tasmota.cmd("Power" + str(lane) + " TOGGLE")
        # end
        # if self.device_type == "Blinds"
        #     tasmota.cmd("ShutterRelay" + str(lane) + " TOGGLE")
        # end
    end

    def do_short_config(channel, lane)
        if lane == 2
            if persist.light_config_mode == "Animation"
                persist.light_config_mode = "Color"   
                self.speak("Duration configuration")
                
                print("TXU: Animation -> Color")
                return         
            end
            if persist.light_config_mode == "Color"
                persist.light_config_mode = "Brightness"   
                self.speak("Brightness configuration")
                print("TXU: Color -> Brightness") 
                return              
            end
            if persist.light_config_mode == "Brightness"
                persist.light_config_mode = "Duration"
                self.speak("Duration configuration")
                print("TXU: Brightness -> Duration") 
                return              
            end                
            
            if persist.light_config_mode == "Duration"
                persist.light_config_mode = "Palette"   
                self.speak("Palette configuration")
                print("TXU: Duration -> Palette")
                return         
            end
            if persist.light_config_mode == "Palette"
                persist.light_config_mode = "Effect"   
                self.speak("Effect configuration")
                print("TXU: Palette -> Effect")
                return
            end
            if persist.light_config_mode == "Effect"
                persist.light_config_mode = "Animation"   
                self.speak("Color configuration")
                print("TXU: Effect -> Animation")
                return
            end
            
        end
        #lane 1 decreases value, lane 3 increases value
        if persist.light_config_mode == "Color"
            if lane == 1
                persist.light_color = persist.light_color - 1
            end
            if lane == 3
                persist.light_color = persist.light_color + 1
            end
            var color = self.get_color()
            var color_key = self.get_color_key()
            self.restart_leds()
            self.speak("Color " + str(color_key))
            print("TXU: Color", color_key, color)
            
        end
        if persist.light_config_mode == "Brightness"
            if lane == 1
                persist.light_brightness = persist.light_brightness - 1
            end
            if lane == 3
                persist.light_brightness = persist.light_brightness + 1
            end                
            var brightness = self.get_brightness()
            var brightness_key = self.get_brightness_key()   
            self.restart_leds()
            self.speak(str(brightness_key) + " percent brightness")
            print("TXU: Brightness", brightness_key, brightness)
        end
        if persist.light_config_mode == "Duration"
            if lane == 1
                persist.light_duration = persist.light_duration - 1
            end
            if lane == 3
                persist.light_duration = persist.light_duration + 1
            end
            var duration = self.get_duration_key()
            self.restart_leds()
            self.speak(str(duration) + " duration")
            print("TXU: Duration", duration)
            
        end
        if persist.light_config_mode == "Animation"
            if lane == 1
                persist.light_animation = persist.light_animation - 1
            end
            if lane == 3
                persist.light_animation = persist.light_animation + 1
            end
            var animation_key = self.get_animation_key()
            var animation = self.get_animation()      
            
            self.restart_leds()      
            self.speak(animation+ "")
            print("TXU: Animation", animation_key, animation)

        end
        if persist.light_config_mode == "Palette"
            if lane == 1
                persist.light_palette = persist.light_palette - 1
            end
            if lane == 3
                persist.light_palette = persist.light_palette + 1
            end
            var palette_key = self.get_palette_key()
            var palette = self.get_palette()       
            
            self.restart_leds()
            self.speak(str(palette_key)+ " palette")
            print("TXU: Palette", palette_key, palette)
        end
        if persist.light_config_mode == "Effect"
            if lane == 1
                persist.light_effect = persist.light_effect - 1
            end
            if lane == 3
                persist.light_effect = persist.light_effect + 1
            end
            var effect_key = self.get_effect_key()
            var effect = self.get_effect()
            
            self.restart_leds()
            self.speak(effect_key+ " effect")
            print("TXU: Effect", effect_key, effect)
        end


    end

    def speak(text)
        tasmota.cmd("I2SSay " + text)
    end


    def get_value_from_var(var_cnt, default_value)
        var value = tasmota.cmd("Var" + str(var_cnt))["Var" + str(var_cnt)] 
        print("TXU: Get value from var", var_cnt, value)
        if value == nil || value == ""
            value = default_value
            self.save_value_to_var(var_cnt, default_value)
        end
        value = int(value)
        return value
    end





    def get_animation_key()
        var index = persist.light_animation
        var animations = self.get_animations()
        #get length of the map
        var length = animations.size()
        #get the key of the map
        var keys = animations.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_animation = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end    
        return key
    end

    def get_animation()
        return self.get_animations()[self.get_animation_key()]
    end


    def get_animations()
        return {
            0: "None",
            1: "Breathe",
            2: "Oscilator",
            6: "Clock",
            7: "Candlelight",
            8: "RGB",
            9: "Christmas",
            10: "Hanukkah",
            11: "Kwanzaa",
            12: "Rainbow",
            13: "Fire",
            14: "Stairs"
        }
    end


    def get_brightness_key()
        var index = persist.light_brightness
        var brightnesses = self.get_brightnesses()
        #get length of the map
        var length = brightnesses.size()
        #get the key of the map
        var keys = brightnesses.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_brightness = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end
        return key
    end

    def get_brightness()        
        return self.get_brightnesses()[self.get_brightness_key()]
    end

    def get_brightnesses()
        return {
            "twenty five": 25,
            "fifty": 50,
            "seventy five": 75,
            "one hundred": 100
        }
    end



    def get_duration_key()
        var index = persist.light_duration
        var durations = self.get_durations()
        #get length of the map
        var length = durations.size()
        #get the key of the map
        var keys = durations.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_duration = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end
        return key
    end

    def get_duration()        
        return self.get_durations()[self.get_duration_key()]
    end

    def get_durations()
        return {
            "one second": 1000,
            "two seconds": 2000,
            "three seconds": 3000,
            "four seconds": 4000,
            "five seconds": 5000,
            "six seconds": 6000,
            "seven seconds": 7000,
            "eight seconds": 8000,
            "nine seconds": 9000,
            "ten seconds": 10000
        }
    end



    def get_color_key()
        var index = persist.light_color
        var colors = self.get_colors()
        #get length of the map
        var length = colors.size()
        #get the key of the map
        var keys = colors.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_color = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end
        return key
    end

    def get_color()
        return  self.get_colors()[self.get_color_key()]
    end

    def get_colors()
        return {
            "White": 0xFFFFFF,
            "Red": 0xFF0000,
            "Green": 0x00FF00,
            "Blue": 0x0000FF,
            "Yellow": 0xFFFF00,
            "Magenta": 0xFF00FF,
            "Cyan": 0x00FFFF,
            "Black": 0x000000,
            "Orange": 0xFFA500,
            "Purple": 0x800080,
            "Pink": 0xFFC0CB,
            "Brown": 0xA52A2A,
            "Grey": 0x808080,
            "Light Grey": 0xA9A9A9,
            "Dark Grey": 0x696969,
            "Light Red": 0xFFC0CB,
            "Light Blue": 0xADD8E6,
            "Light Green": 0x90EE90,
            "Light Yellow": 0xFFFFE0,
            "Light Pink": 0xFFB6C1,
            "Light Purple": 0x9400D3,
            "Light Orange": 0xFF8C00,
            "Light Brown": 0xCD853F,
            "Light Cyan": 0x00CED1,
            "Light Magenta": 0xBA55D3,
            "Dark Blue": 0x00008B,
            "Dark Green": 0x006400,
            "Dark Yellow": 0x808000,
            "Dark Pink": 0xFF1493,
            "Dark Purple": 0x800080,
            "Dark Orange": 0xFF8C00,
            "Dark Brown": 0x8B4513,
            "Dark Cyan": 0x008B8B,
            "Dark Magenta": 0x8B008B
        }
    end



    def get_palette_key()
        var index = persist.light_palette
        var palettes = self.get_palettes()
        #get length of the map
        var length = palettes.size()
        #get the key of the map
        var keys = palettes.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_palette = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end
        return key
    end

    def get_palette()       
        return self.get_palettes()[self.get_palette_key()]
    end

    def get_palettes()
        return {
            "Rainbow White": animate.PALETTE_RAINBOW_WHITE,
            "Standard Tag": animate.PALETTE_STANDARD_TAG,
            "Standard Value": animate.PALETTE_STANDARD_VAL,
            "Saturated Tag": animate.PALETTE_SATURATED_TAG,
            "ib jul01 gp": animate.PALETTE_ib_jul01_gp,
            "ib 44": animate.PALETTE_ib_44,
            "bhw1 sunconure": animate.PALETTE_bhw1_sunconure,
            "bhw4 089": animate.PALETTE_bhw4_089

        }
    end

    def get_effect_key()
        var index = persist.light_effect
        var effects = self.get_effects()
        #get length of the map
        var length = effects.size()
        #get the key of the map
        var keys = effects.keys()
        #get the index of the key
        var pos = (index + length) % length
        persist.light_effect = pos
        var i = 0
        var key = 0
        for k : keys
            if i == pos
                key = k
                break
            end
            i = i + 1
        end
        return key
    end

    def get_effect()
        return self.get_effects()[self.get_effect_key()]
    end

    def get_effects()
        return {
            "square": animate.SQUARE,
            "triangle": animate.TRIANGLE,
            "cosine": animate.COSINE,
            "sawtooth": animate.SAWTOOTH
        }
    end





    def init_leds()
        self.strip = Leds(persist.led_cnt, gpio.pin(gpio.WS2812, 0))
        self.anim = animate.core(self.strip)
        self.set_leds()
    end



    def reset_leds()
        print ("TXU: Reset leds")
        self.anim.clear()
        self.anim.stop()
        self.anim.remove()

        self.anim = animate.core(self.strip)
        
        if self.pulse != nil

            self.pulse = nil
        end
        if self.oscillator != nil
            #self.oscillator.set_cb(nil, nil)
            self.oscillator = nil
        end
        if self.palette != nil
            #self.palette.set_cb(nil, nil)
            self.palette = nil
        end
    end

    def restart_leds()
        persist.save()
        self.reset_leds()
        self.set_leds()
    end

    def set_leds()
       
        var anim_key = self.get_animation_key()
        print("TXU: Animation", anim_key)
        if(persist.light_on == 0)
            self.reset_leds()
            return
        end
        
       

        if anim_key>5
            self.reset_leds()
            self.strip.clear()
            tasmota.cmd("Scheme "+ str(anim_key))
            return
        else 
            tasmota.cmd("Scheme 15")
            self.reset_leds()
            self.strip.clear()
            self.anim.set_bri(self.get_brightness())   
            if anim_key == 0
                self.set_leds_fixed_color()
            end
            if anim_key == 1
                self.set_leds_breathe()
            end
            if anim_key == 2
                self.set_leds_pulse_oscillator()
            end
        end
    
       

        self.anim.start()
    end



  

    def set_leds_fixed_color()
        print("TXU: Fixed color", self.get_color())
        self.anim.set_back_color(self.get_color())
    end

    
   
    


    def set_leds_pulse_oscillator()
        var color = self.get_color()
        print("TXU: Pulse oscillator", color)

        self.anim.set_back_color(color)                 
        self.pulse = animate.pulse(0xFF4444, 2, 1)
        self.oscillator = animate.oscillator(-3, persist.led_cnt+3, self.get_duration(), self.get_effect())
        self.oscillator.set_cb(self.pulse, self.pulse.set_pos)
        self.palette = animate.palette(self.get_palette(), self.get_duration())
        self.palette.set_cb(self.pulse, self.pulse.set_color)
    end

    def set_leds_breathe()
        var color = self.get_color()
        self.anim.set_back_color(0x000000)
        print("TXU: Breathe", color)
        self.pulse = animate.pulse(color, persist.led_cnt, 0)
        self.palette = animate.palette(self.get_palette())
        self.palette.set_range(0, 255)
        self.palette.set_cb(self.pulse, self.pulse.set_color)
        
        self.oscillator = animate.oscillator(50, 255, self.get_duration(), self.get_effect())
        self.oscillator.set_cb(self.palette, self.palette.set_value)
    end

    def set_leds_switch()
        self.anim.add_background_animator(animate.palette(self.get_palette(), self.get_duration()))
    end

    


    def init(tx, rx)
        tasmota.add_driver(self)
        self.device_mode = "Normal" # values: Normal, Config
        persist.light_config_mode = "Animation" # values: Color, Brightness, Animation

        var config_changed = 0

        if persist.has("device_type") == false
            persist.device_type =  "Light"
            config_changed = 1
        end


        if persist.has("led_cnt") == false
            persist.led_cnt = 25
            config_changed = 1
        end
        
        if persist.has("light_color") == false
            persist.light_color = 0
            config_changed = 1
        end

        if persist.has("light_duration") == false
            persist.light_duration = 3
            config_changed = 1
        end

        if persist.has("light_brightness") == false
            persist.light_brightness = 3
            config_changed = 1
        end

        if persist.has("light_animation") == false
            persist.light_animation = 0
            config_changed = 1
        end

        if persist.has("light_on") == false
            persist.light_on = 0
            config_changed = 1
        end

        if persist.has("light_palette") == false
            persist.light_palette = 0
            config_changed = 1
        end

        if persist.has("light_effect") == false
            persist.light_effect = 0
            config_changed = 1
        end
               

        if(config_changed == 1)
            persist.save()
        end
      
        self.init_leds()

        var ob = self
        tasmota.add_rule("TXUltimate#Action",def (value, trigger, msg) ob.handle_action(value, trigger, msg) end)
    end

    
    


end

txum=TXUltimateMode()