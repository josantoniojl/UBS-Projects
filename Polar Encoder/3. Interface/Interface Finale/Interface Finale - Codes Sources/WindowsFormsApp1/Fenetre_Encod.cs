using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.IO;

namespace Codes_Polaires
{
    public partial class Fenetre_Encod : Form
    {
        public int nb_Octets;
        public int compteur;
        private object nb_Octet;

        public Fenetre_Encod()
        {
            InitializeComponent();
            getAvailablePorts();
            init_Form();
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            if(ofd.ShowDialog() == DialogResult.OK)
            {
                textBox2.Text = ofd.FileName;
            }
        }


        void getAvailablePorts()
        {
            String[] Ports = SerialPort.GetPortNames();
            comboBox1.Items.AddRange(Ports);
        }

        void init_Form()
        {

            textBox2.Text = Directory.GetCurrentDirectory() +  "/Init_Msg_Enc.txt";
            textBox3.Text = Directory.GetCurrentDirectory();
            textBox4.Text = "Output_Result_Encoder";
            comboBox3.Text = "8";
            textBox1.Text  = "5";


        }


        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar < '0' || e.KeyChar > '9')
            {
                e.KeyChar = (char)0;
            }
            else
            {
                if(textBox1.TextLength == 4)
                {
                    e.KeyChar = (char)0;
                }
            }
        }

        private void button2_MouseClick(object sender, MouseEventArgs e)
        {
            FolderBrowserDialog dir = new FolderBrowserDialog();
            if (dir.ShowDialog() == DialogResult.OK)
            {
                textBox3.Text = dir.SelectedPath;
            }
        }

        private void btn_Encod_MouseClick(object sender, MouseEventArgs e)
        {
            try
            {
          
                if (textBox2.Text == null)
                {
                    MessageBox.Show("Pas de fichier texte !", ("ERROR") ,MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                {
                    if (textBox3.Text == null)
                    {
                        MessageBox.Show("Aucun dossier de sauvegarde !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    else
                    {
                        if(textBox4.Text == null)
                        {
                            MessageBox.Show("Aucun nom de fichier !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                        else
                        {
                            if (comboBox1.Text == null)
                            {
                                MessageBox.Show("Pas de nom du port !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                            else
                            {
                                if (comboBox3.Text == null)
                                {
                                    MessageBox.Show("Pas de taille N !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                                }
                                else
                                {
                                    if (textBox1.Text == null)
                                    {
                                        MessageBox.Show("Pas de taille K !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                                    }
                                    else
                                    { 

                                        if (Convert.ToUInt16(textBox1.Text) > Convert.ToUInt16(comboBox3.Text))
                                        {
                                            MessageBox.Show("K supérieur à N !", ("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                                        }
                                        else
                                        { 
                                            string path = textBox3.Text + "/" + textBox4.Text + ".txt";

                                            int N = Convert.ToUInt16(comboBox3.Text);
                                            int K = Convert.ToUInt16(textBox1.Text);


                                            if (File.Exists(path))
                                            {
                                                File.Delete(path);
                                            }

                                            string init_taille = groupBox2.Text + " : \r\n\r\nN = " + comboBox3.Text + "\r\nK = " + textBox1.Text + "\r\n\r\nMessage originel : \r\n\r\n";

                                            FileStream fileWrite = new FileStream(path,FileMode.CreateNew);
                                            using (StreamWriter swWrite = new StreamWriter(fileWrite, System.Text.Encoding.Default))
                                            {
                                                FileStream fileRead = new FileStream(textBox2.Text, FileMode.Open);
                                                nb_Octet = fileRead.Length;
                                                using (StreamReader swRead = new StreamReader(fileRead, System.Text.Encoding.Default))
                                                {
                                                    swWrite.Write(init_taille);
                                                    swWrite.Write(swRead.ReadToEnd());
                                                    swWrite.Write("\r\n\r\n\r\nMessage encodé :\r\n\r\n");
                                                }
                                                fileRead.Close();
                                            }

                                            fileWrite.Close();

                                            if (!serialPort1.IsOpen)
                                            {

                                                serialPort1.PortName = comboBox1.Text;
                                                serialPort1.BaudRate = 9600;
                                                serialPort1.Parity = Parity.None;
                                                serialPort1.DataBits = 8;
                                                serialPort1.StopBits = StopBits.One;
                                                serialPort1.Encoding = System.Text.Encoding.ASCII; //Ou UTF8

                                                serialPort1.Open();
                                            }
                                            else
                                            {
                                                serialPort1.Close();

                                                serialPort1.PortName = comboBox1.Text;
                                                serialPort1.BaudRate = 9600;
                                                serialPort1.Parity = Parity.None;
                                                serialPort1.DataBits = 8;
                                                serialPort1.StopBits = StopBits.One;
                                                serialPort1.Encoding = System.Text.Encoding.ASCII; //Ou UTF8

                                                serialPort1.Open();
                                            }


                                            byte[] sizeN = BitConverter.GetBytes(Convert.ToUInt16(comboBox3.Text));
                                            byte[] sizeK = BitConverter.GetBytes(Convert.ToUInt16(textBox1.Text));
                                            char[] EOT = new char[1];

                                            EOT[0] = (char) 0xFF;

                                            serialPort1.Write(sizeN, 0,sizeN.Length); //Envoi : Taille N et 0
                                            serialPort1.Write(sizeK, 0, sizeK.Length); //Envoi : Taille K et 0

                                            //Log2(N)
                                            byte[] LogN = { 0,0 };
                                            LogN[0] = (byte)Math.Log(sizeN[0],2);
                                            serialPort1.Write(LogN, 0, LogN.Length); //Envoi : Log2(N)

                                            FileStream fileRead2 = new FileStream(textBox2.Text, FileMode.Open);
                                            using (StreamReader swRead2 = new StreamReader(fileRead2, System.Text.Encoding.Default))
                                            {
                                                serialPort1.Write(swRead2.ReadToEnd());
                                            }

                                            //serialPort1.Write(EOT,0,EOT.Length); //Envoi : Transmission terminée (End Of Transmission)

                                            fileRead2.Close();
                                        } 
                                    }
                                } 
                            } 
                        }
                    }
                }
            }

            catch (Exception err)
            {
                MessageBox.Show(err.Message,("ERROR"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }

        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            
            string path = textBox3.Text + "/" + textBox4.Text + ".txt";
            
            FileStream fileWrite = new FileStream(path,FileMode.Append);
            using (StreamWriter swWrite = new StreamWriter(fileWrite, System.Text.Encoding.Default))
            {
                swWrite.Write(serialPort1.ReadExisting());
            }

            fileWrite.Close();

        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                serialPort1.Close();
                MessageBox.Show("Port série fermé ! ", ("Information"), MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void groupBox3_Enter(object sender, EventArgs e)
        {

        }

        private void Fenetre_Encod_Load(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            MessageBox.Show(" INTERFACE POUR ENCODEUR VHDL CODES POLAIRES\n\n\n\n         Conceived by William LAMBOGLIA FERREIRA", "À propos de");

            const string message = "Voulez-vous visiter le site internet de la Faculté des Sciences ?";
            const string caption = "Université de Bretagne Sud";
            var result = MessageBox.Show(message, caption, MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                System.Diagnostics.Process.Start("http://www-facultesciences.univ-ubs.fr/fr/index.html");
            }
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }
    }
}
