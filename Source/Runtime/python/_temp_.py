# classname
class classname:
     # tkinter window
     import tkinter as tk
     win = tk.Tk()
     
     # title
     win.title('tkinter window')
     
     # width/height/left/top
     win.geometry('400x300+100+100')
     win.configure(background="#F0F0F0")
     
     labeltext = """
     tk_label
     """
     label0 = tk.Label(win, text=labeltext, bg="#F0F0F0", font=("", 0),justify="left", anchor="w")
     label0.place(x=20,y=20, width=150, height=30)
     
     text1 = tk.Text(win,  font=("", 0))
     for item in ["tk_text"]:
          text1.insert("end", item)
     text1.place(x=200,y=20, width=150, height=60)
     
     win.mainloop()
     
     
     # 1 > 0
     if 1 > 0:
          # tkinter window
          import tkinter as tk
          win = tk.Tk()
          
          # title
          win.title('tkinter window')
          
          # width/height/left/top
          win.geometry('400x300+100+100')
          win.configure(background="#F0F0F0")
          
          labeltext = """
          tk_label
          """
          label0 = tk.Label(win, text=labeltext, bg="#F0F0F0", font=("", 0),justify="left", anchor="w")
          label0.place(x=20,y=20, width=150, height=30)
          
          radio1 = tk.Radiobutton(win,text="tk_radio",  font=("", 0), anchor="w")
          radio1.place(x=20,y=180, width=150, height=30)
          
          win.mainloop()
          
          
          
     else:
          
     
     



