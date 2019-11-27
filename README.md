PbCounter
=========

PbCounter is a small Windows utility that counts how many times each mouse button and each keyboard key is pressed. 
With these statistics it does three things:

 - Display the counters, obviously :)
 - Create an heat map to put in evidence the most used keys on your keyboard
 - Upload the statistics at regular interval to a web page of your choice (an example PHP script here or source)

It is purposely compatible with scripts made for Mousotron[1]. It takes less than 3MB of ram and uses very little CPU.

On first run the application will create an ini file with default settings.

To make PbCounter run on windows startup place a shortcut to counter.exe in the Startup folder of your Start Menu.
 
Here are some settings you may want to change (Important to quit PbCounter before editing the ini file!):
 - computername: This is used when the script sends statistics over the internet. By default it is your computer name.
 - updateinterval: This is the time in second between web statistics update.
 - updateenabled: Whether or not to use periodic web statistics upload (if you set this to 0 you can still press 
   the Update Now button to send your stats)
 - updateurl: The url of the remote statistics script


HTTP Web Update Format
----------------------
 - al = ComputerName
 - reset = last time the counters were reset
 - lb = left clicks
 - rb = right clicks
 - mb = middle clicks
 - eb = extra button clicks
 - scr = wheel scrolls
 - ks = keystrokes


1. http://www.blacksunsoftware.com/mousotron.html


Limitations
===========
The keyboard heatmap is hard coded to qwerty layout, eventually I'll make it dynamic but for now please know that
the key counters correctly mapped. You might not see your layout, but Q on the map is still Q on your keyboard!


Screenshots
===========
![Main Window](https://raw.githubusercontent.com/ducalex/pbcounter/master/screenshots/main-window.png)
![Heatmap](https://raw.githubusercontent.com/ducalex/pbcounter/master/screenshots/heatmap.png)


Credits
=======
 - Keyboard icon by famfamfam


License
=======
Copyright (c) 2014 Alex Duchesne <alex@alexou.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.