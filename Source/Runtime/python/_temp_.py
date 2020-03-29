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
label0 = tk.Label(win, text=labeltext, bg="#F0F0F0", font=("Consolas", 14),justify="center", anchor="center")
label0.place(x=20,y=20, width=360, height=30)

labeltext = """
Age
"""
label1 = tk.Label(win, text=labeltext, bg="#F0F0F0", font=("Courier New", 10),justify="left", anchor="w")
label1.place(x=20,y=60, width=150, height=30)

entry2 = tk.Entry(win,  font=("Courier New", 10))
entry2.place(x=200,y=60, width=150, height=30)

button3 = tk.Button(win, text="LOGIN",  font=("Courier New", 10))
button3.place(x=120,y=100, width=150, height=30)

win.mainloop()

