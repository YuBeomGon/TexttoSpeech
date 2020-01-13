from google.cloud import texttospeech
import re
import fileinput
#import pandas

def Text2Speech(id, transcript, sex, speed, pitch_):
    # Instantiates a client
    client = texttospeech.TextToSpeechClient()

    # Set the text input to be synthesized
    synthesis_input = texttospeech.types.SynthesisInput(text=transcript)

    # Build the voice request, select the language code ("en-US") and the ssml
    # voice gender ("neutral")
    if sex == "neutral":
        gender=texttospeech.enums.SsmlVoiceGender.NEUTRAL
    elif sex == "male":
        gender=texttospeech.enums.SsmlVoiceGender.MALE
    elif sex == "female":
        gender=texttospeech.enums.SsmlVoiceGender.FEMALE
    else:
        print("error, please check the sex")
    
    voice = texttospeech.types.VoiceSelectionParams(
        language_code='ko-KR',
        ssml_gender=gender)
    
    if speed == "slow":
        srate = 0.8
    elif speed == "mid":
        srate = 1.0
    elif speed == "fast":
        srate = 1.2
    else:
        print("error, please check the speed")

    if pitch_ == "m5":
        pit = -5
    elif pitch_ == "zero":
        pit = 1
    elif pitch_ == "p5":
        pit = 5
    else:
        print("error, please check the pitch")
    

    # Select the type of audio file you want returned
    audio_config = texttospeech.types.AudioConfig(
        speaking_rate=srate,
        sample_rate_hertz=16000,
        pitch=pit,
        audio_encoding=texttospeech.enums.AudioEncoding.LINEAR16)

    # Perform the text-to-speech request on the text input with the selected
    # voice parameters and audio file type
    response = client.synthesize_speech(synthesis_input, voice, audio_config)
    #print(id)
    
    filename = "audio1/" + id +".wav"
    print(filename)

    # The response's audio_content is binary.
    with open(filename, 'wb') as out, open('wav.scp', 'at') as outf:
        wa = id + " " + filename + '\n'
        outf.write(wa)
        # Write the response to the output file.
        out.write(response.audio_content)
        print('Audio content written to file,', filename)
    
    #wav.scp
#     with open('wav.scp', 'at') as out:
#         # Write the response to the output file.
#         wa = id + " " + filename + '\n'
#         out.write(wa)
#         print('Audio content written to file,', 'wav.scp')     

def main():
    with open("/home/beomgon2/TexttoSpeech/text.scp", 'rt') as f, open('/home/beomgon2/TexttoSpeech/wav.scp', 'wt') as out :
        line = f.readline()
        while line:
            line = re.sub('\t\r\f\v', ' ', line)
            file = line.split()
            filename = file[0]
            id = filename.split('_')
            sex = id[0]
            speed = id[2]
            pitch = id[4]
            #print(sex)
            #print(speed)
            #print(pitch)
            #print(filename[0])
            #print(filename[1:])
            utt = ",".join(file[1:])
            utt = re.sub(',', " ", utt)
            print(filename, utt)
            Text2Speech(filename, utt, sex, speed, pitch)
            line = f.readline()


if __name__ == "__main__":
    main()        
