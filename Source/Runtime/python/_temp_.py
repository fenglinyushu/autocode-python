# tkinter window
import tkinter as tk
win = tk.Tk()

# title
win.title('tkinter window')

# width/height/left/top
win.geometry('400x300+100+100')
win.configure(background="#F0F0F0")

labeltext = """
ACP System
"""
label0 = tk.Label(win, text=labeltext, bg="#C8C8C8", font=("Consolas", 14),justify="center", anchor="center")
label0.place(x=20,y=20, width=150, height=30)

button1 = tk.Button(win, text="tk_button",  font=("Courier New", 10))
button1.place(x=20,y=60, width=150, height=30)

win.mainloop()

