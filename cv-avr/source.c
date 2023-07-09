#include <mega32.h>

#define OFF 0
#define UP 1
#define DOWN 2
#define OPEN 1
#define CLOSE 2

#define NOT_BLINKING 0
#define BLINKING 1

unsigned char current_state = 3;
//0: door should open
//1: waiting before door close
//2: closing the door
//3: waiting for request
//4: moving to request

unsigned char height_from_ground = 0;
unsigned char current_floor = 0;
unsigned char door_open_degree = 0; // 0: close 20:full open
unsigned char open_door_wait = 0;

unsigned char inferared_trigered = 0;
unsigned char heavy_weight = 0;
unsigned char alarm = 0;

unsigned char destination_heights[4] = {0, 10, 20, 30};
char destination_height = 30;
char destination_set = 0;

unsigned char current_door_motor_mode = OFF;
unsigned char current_elevator_motor_mode = OFF;
unsigned char monitor_blinking = NOT_BLINKING;
unsigned char monitor_on = 1;
unsigned char blink_time = 0;

unsigned char requested[4] = {0, 0, 0, 0};
unsigned char seg_code[4] = {0b00111111, 0b00000110, 0b01011011, 0b01001111};

void read_inferared(){
    if (PINA.0 == 0){
        inferared_trigered = 1;
    }
}

void read_alarm(){
    if (PINA.1 == 0){
        alarm = 1;
    }
}

void read_heavyweight(){
    if (PINA.2 == 0){
        heavy_weight = 1;
    }
}

void read_buttons(){
    if (PINC.0 == 0 || PINC.1 == 0 || PINC.2 == 0 || PINC.3 == 0){
        if (PINC.0 == 0){
            requested[0] = 1;
        }
        if (PINC.1 == 0){
            requested[1] = 1;
        }
        if (PINC.2 == 0){
            requested[2] = 1;
        }
        if (PINC.3 == 0){
            requested[3] = 1;
        }
    }
    else {
        if (PINC.4 == 0){
            requested[0] = 1;
        }
        if (PINC.5 == 0){
            requested[1] = 1;
        }
        if (PINC.6 == 0){
            requested[2] = 1;
        }
        if (PINC.7 == 0){
            requested[3] = 1;
        }
    }
}

void elevator_motor(int mode){
    unsigned char a;
    unsigned char b;
    if (mode == OFF){
        a = 0;
        b = 0;
    }
    else{
        if (mode == UP){
            height_from_ground++;
            a = 1;
            b = 0;
        }
        else{
             if (mode == DOWN){
                height_from_ground--;
                a = 0;
                a = 1;
            }
        }
    }

    if (current_elevator_motor_mode != mode){
        PORTD.0 = a;
        PORTD.1 = b;
        current_elevator_motor_mode = mode;
    }
}

void door_motor(int mode){
    unsigned char a;
    unsigned char b;
    if (mode == OFF){
        a = 0;
        b = 0;
    }
    else{
         if (mode == OPEN){
            door_open_degree++;
            a = 1;
            b = 0;
        }
        else {
                if (mode == CLOSE){
                door_open_degree--;
                a = 0;
                b = 1;
            }
        }
    }

    if (current_door_motor_mode != mode){
        PORTD.2 = a;
        PORTD.3 = b;
        current_door_motor_mode = mode;
    }
}

void update_seven_segment(){
    if (monitor_blinking == NOT_BLINKING){
        monitor_on = 1;
        blink_time = 0;
    }
    else{
        if (blink_time == 3){
            blink_time = 0;
            monitor_on = !monitor_on;
        }
        else {
            blink_time++;
        }
    }


    if (monitor_on){
        PORTB = seg_code[current_floor];
    }
    else{
        PORTB = 0x00;
    }
}

// do
void set_destination(){
    signed int i_best;
    signed int d = 1000;
    signed int dtemp;
    signed int found = 0;
        
    unsigned char i;
    for (i=0; i<4; i++){
        if (requested[i]){
            if (height_from_ground < destination_heights[i]){
                dtemp = destination_heights[i] - height_from_ground;
            }
            else {
                dtemp = height_from_ground - destination_heights[i];
            }
            
            if (dtemp < d){
                found = 1;
                i_best = i;
                d = dtemp;
            }
        }
    }
    if (found == 1){
        destination_height = destination_heights[i_best];
        destination_set = 1;
        return;
    }
}

unsigned char closest_floor_height(){
    unsigned char result = (height_from_ground / 10)*10;
    if (height_from_ground < destination_height){
        result += 10;
    }
    return result;
}

void time_interupt(){
    update_seven_segment();

    // door opening
    if (current_state == 0){
        monitor_blinking = BLINKING;
        if (door_open_degree < 20){
            door_motor(OPEN);
        }
        else{
            door_motor(OFF);
            open_door_wait = 10;
            current_state = 1;
        }
        return;
    }

    // waiting door opened
    if (current_state == 1){
        if (open_door_wait > 0){
            open_door_wait--;
        }
        else{
            current_state = 2;
        }
        return;
    }

    // door closing
    if (current_state == 2){
        read_inferared();
        if (inferared_trigered == 1){
            inferared_trigered = 0;
            current_state = 0;
        }
        else {
            if(door_open_degree > 0){
                door_motor(CLOSE);
            }
            else {
                door_motor(OFF);
                current_state = 3;
            }
        }
        return;
    }

    // choosing next destination
    if (current_state == 3){
        read_alarm();
        read_heavyweight();
        monitor_blinking = NOT_BLINKING;
        if (alarm == 1 || heavy_weight == 1){
            destination_height = height_from_ground;
            destination_set = 1;
            current_state = 4;
        }
        else {
            if (!destination_set){
                read_buttons();
                set_destination();
                current_state = 3;
            }
            else{
                current_state = 4;
            }
        }
        return;
    }

    // moving to next destination
    if (current_state == 4){
        read_alarm();
        read_heavyweight();
        // update current floor
        if (height_from_ground % 10 == 0){
            current_floor = height_from_ground / 10;
        }

        if (heavy_weight == 1){
            heavy_weight = 0;
            alarm = 1;
        }

        if (alarm == 1){
            destination_height = closest_floor_height();
            alarm = 0;
        }

        if (height_from_ground < destination_height){
            elevator_motor(UP);
        }
        else{
             if (height_from_ground > destination_height){
                elevator_motor(DOWN);
            }
            else {
                elevator_motor(OFF);
                requested[height_from_ground/10] = 0;// removing request
                destination_set = 0;// removing destination
                current_state = 0;
            }
        }
        return;
    }
}


interrupt [TIM0_OVF] void timer0_ovf_isr(void){
// Reinitialize Timer 0 value
   TCNT0=0x9E;
   time_interupt();
}


void main(void)
{
DDRA=0x00;
PORTA=0xff;

DDRB=0xff;
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=0x00;
PORTC=0xff;

DDRD=0xff;
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x9E;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// Global enable interrupts
#asm("sei")

while (1){
}
}
