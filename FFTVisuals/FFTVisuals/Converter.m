//
//  Converter.m
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "Converter.h"

@implementation Converter

+(NSString*)note:(NSInteger)midi
{
    
    if(midi == 0){
        return @"C0";
    }else if(midi == 1){
        return @"C#0";
    }else if(midi == 2){
        return @"D0";
    }else if(midi == 3){
        return @"D#0";
    }else if(midi == 4){
        return @"E0";
    }else if(midi == 5){
        return @"F0";
    }else if(midi == 6){
        return @"F#0";
    }else if(midi == 7){
        return @"G0";
    }else if(midi == 8){
        return @"G#0";
    }else if(midi == 9){
        return @"A0";
    }else if(midi == 10){
        return @"A#0";
    }else if(midi == 11){
        return @"B0";
    }else if(midi == 12){
        return @"C1";
    }else if(midi == 13){
        return @"C#1";
    }else if(midi == 14){
        return @"D1";
    }else if(midi == 15){
        return @"D#1";
    }else if(midi == 16){
        return @"E1";
    }else if(midi == 17){
        return @"F1";
    }else if(midi == 18){
        return @"F#1";
    }else if(midi == 19){
        return @"G1";
    }else if(midi == 20){
        return @"G#1";
    }else if(midi == 21){
        return @"A1";
    }else if(midi == 22){
        return @"A#1";
    }else if(midi == 23){
        return @"B1";
    }else  if(midi == 24){
        return @"C2";
    }else if(midi == 25){
        return @"C#2";
    }else if(midi == 26){
        return @"D2";
    }else if(midi == 27){
        return @"D#2";
    }else if(midi == 28){
        return @"E2";
    }else if(midi == 29){
        return @"F2";
    }else if(midi == 30){
        return @"F#2";
    }else if(midi == 31){
        return @"G2";
    }else if(midi == 32){
        return @"G#2";
    }else if(midi == 33){
        return @"A2";
    }else if(midi == 34){
        return @"A#2";
    }else if(midi == 35){
        return @"B2";
    }else if(midi == 36){
        return @"C3";
    }else if(midi == 37){
        return @"C#3";
    }else if(midi == 38){
        return @"D3";
    }else if(midi == 39){
        return @"D#3";
    }else if(midi == 40){
        return @"E3";
    }else if(midi == 41){
        return @"F3";
    }else if(midi == 42){
        return @"F#3";
    }else if(midi == 43){
        return @"G3";
    }else if(midi == 44){
        return @"G#3";
    }else if(midi == 45){
        return @"A3";
    }else if(midi == 46){
        return @"A#3";
    }else if(midi == 47){
        return @"B3";
    }else if(midi == 48){
        return @"C4";
    }else if(midi == 49){
        return @"C#4";
    }else if(midi == 50){
        return @"D4";
    }else if(midi == 51){
        return @"D#4";
    }else if(midi == 52){
        return @"E4";
    }else if(midi == 53){
        return @"F4";
    }else if(midi == 54){
        return @"F#4";
    }else if(midi == 55){
        return @"G4";
    }else if(midi == 56){
        return @"G#4";
    }else if(midi == 57){
        return @"A4";
    }else if(midi == 58){
        return @"A#4";
    }else if(midi == 59){
        return @"B4";
    }else if(midi == 60){
        return @"C5";
    }else if(midi == 61){
        return @"C#5";
    }else if(midi == 62){
        return @"D5";
    }else if(midi == 63){
        return @"D#5";
    }else if(midi == 64){
        return @"E5";
    }else if(midi == 65){
        return @"F5";
    }else if(midi == 66){
        return @"F#5";
    }else if(midi == 67){
        return @"G5";
    }else if(midi == 68){
        return @"G#5";
    }else if(midi == 69){
        return @"A5";
    }else if(midi == 70){
        return @"A#5";
    }else if(midi == 71){
        return @"B5";
    }else if(midi == 72){
        return @"C6";
    }else if(midi == 73){
        return @"C#6";
    }else if(midi == 74){
        return @"D6";
    }else if(midi == 75){
        return @"D#6";
    }else if(midi == 76){
        return @"E6";
    }else if(midi == 77){
        return @"F6";
    }else if(midi == 78){
        return @"F#6";
    }else if(midi == 79){
        return @"G6";
    }else if(midi == 80){
        return @"G#6";
    }else if(midi == 81){
        return @"A6";
    }else if(midi == 82){
        return @"A#6";
    }else if(midi == 83){
        return @"B6";
    }else if(midi == 84){
        return @"C7";
    }else if(midi == 85){
        return @"C#7";
    }else if(midi == 86){
        return @"D7";
    }else if(midi == 87){
        return @"D#7";
    }else if(midi == 88){
        return @"E7";
    }else if(midi == 89){
        return @"F7";
    }else if(midi == 90){
        return @"F#7";
    }else if(midi == 91){
        return @"G7";
    }else if(midi == 92){
        return @"G#7";
    }else if(midi == 93){
        return @"A7";
    }else if(midi == 94){
        return @"A#7";
    }else if(midi == 95){
        return @"B7";
    }else if(midi == 96){
        return @"C8";
    }else if(midi == 97){
        return @"C#8";
    }else if(midi == 98){
        return @"D8";
    }else if(midi == 99){
        return @"D#8";
    }else if(midi == 100){
        return @"E8";
    }else if(midi == 101){
        return @"F8";
    }else if(midi == 102){
        return @"F#8";
    }else if(midi == 103){
        return @"G8";
    }else if(midi == 104){
        return @"G#8";
    }else if(midi == 105){
        return @"A8";
    }else if(midi == 106){
        return @"A#8";
    }else if(midi == 107){
        return @"B8";
    }else if(midi == 108){
        return @"C9";
    }else if(midi == 109){
        return @"C#9";
    }else if(midi == 110){
        return @"D9";
    }else if(midi == 111){
        return @"D#9";
    }else if(midi == 112){
        return @"E9";
    }else if(midi == 113){
        return @"F9";
    }else if(midi == 114){
        return @"F#9";
    }else if(midi == 115){
        return @"G9";
    }else if(midi == 116){
        return @"G#9";
    }else if(midi == 117){
        return @"A9";
    }else if(midi == 118){
        return @"A#9";
    }else if(midi == 119){
        return @"B9";
    }else if(midi == 120){
        return @"C10";
    }else if(midi == 121){
        return @"C#10";
    }else if(midi == 122){
        return @"D10";
    }else if(midi == 123){
        return @"D#10";
    }else if(midi == 124){
        return @"E10";
    }else if(midi == 125){
        return @"F10";
    }else if(midi == 126){
        return @"F#10";
    }else if(midi == 127){
        return @"G10";
    }else{
        return @"";
    }
}

+(int)midi:(float)freq
{
    return (log(freq) - log(440.0)) / log(2) * 12 + 69;
}

@end
