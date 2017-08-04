# -*- coding: utf-8 -*-
def str_stem(s): 
    if isinstance(s, str):
        s = re.sub(r"(\w)\.([A-Z])", r"\1 \2", s) #Split words with a.A
        s = s.lower()
        s = s.replace("#", "").replace("@","")
        s = s.replace("  "," ")
        s = s.replace(",","") #could be number / segment later
        s = s.replace("$"," ")
        s = s.replace("?"," ")
        s = s.replace("-"," ")
        s = s.replace("//","/")
        s = s.replace(".."," ")
        s = s.replace(" / "," ").replace('/',' ')
        s = s.replace(" \\ "," ")
        s = s.replace("."," . ")
        s = re.sub(r"(^\.|/)", r"", s)
        s = re.sub(r"[0-9]", r"", s)
        s = re.sub(r"(\.|/)$", r"", s)
        
        s = s.replace("  "," ")
        s = s.replace(" . "," ")
        #s = (" ").join([z for z in s.split(" ") if z not in stop_w])
        #s = (" ").join([str(strNum[z]) if z in strNum else z for z in s.split(" ")])
        #s = (" ").join([stemmer.stem(z) for z in s.split(" ")])
        
        s = s.lower()
        s = re.sub(r" [A-Za-z] ", r" ", s)        
        s = re.sub(r"^[A-Za-z] ", r" ", s)
        
        s = re.sub(r'<( *)\w+( *)>', ' ', s)
        s = re.sub(r'<( *)/\w+( *)>', ' ', s)
        s = re.sub(r'<!( *)\w+( *)>', ' ', s)
        s = re.sub(r'<(( *)\w*=*( *))*>',' ', s)
        s = s.replace('<li>',' ').replace('</li>', ' ')
        s = s.replace('<b>',' ').replace('</b>', ' ')
        
        s = s.replace('loadshedding','load shedding')
        s = s.replace('sheddingmi', 'shedding')
        
        # Remove Romanized local language words
        #s = re.sub(r"ki ",r"", s); s = re.sub(r" ki",r"", s)
        #s = s.replace(' se ',' ').replace(' sy ',' ')
        #s = re.sub(r"se ",r"", s); s = re.sub(r" se",r"", s)
        #s = re.sub(r"sy ",r"", s); s = re.sub(r" sy",r"", s)
        #s = re.sub(r"ka ",r"", s); s = re.sub(r" ka",r"", s)
        
        s = s.replace(' ne ',' ').replace(' ny ',' ')
        s = s.replace(' hy ',' ')
        s = s.replace(' kerna ',' ').replace(' kerni ',' ').replace(' karna ',' ').replace(' karni ',' ').replace(' kar ',' ')
        s = s.replace(' ka ', ' ').replace(' ko ', ' ').replace(' ki ', ' ').replace('ki ',' ')
        s = s.replace(' ho ', ' ').replace(' pr ', ' ')
        s = s.replace(' se ', ' ').replace(' ne ', ' ')
        
        # Remove Mark up
        s = s.replace('<h1>',' ').replace('</h1>', ' ')
        s = s.replace('<ul>',' ').replace('</ul>', ' ')
        s = s.replace('<br>',' ').replace('</br>', ' ')
        s = s.replace('<a>',' ').replace('</a>', ' ')
        s = s.replace('<strong>',' ').replace('</strong>', ' ')
        s = s.replace('<sup>',' ').replace('</sup>', ' ')
        s = s.replace('<shorttext>',' ').replace('</shorttext>', ' ')
        s = s.replace('<p>',' ').replace('</p>', ' ')
        s = s.replace(':',' ')
        s = s.replace('\'s','')

        return ' '.join(s.split())
    else:
        return "null"
