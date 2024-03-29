package pages.utils;

import javax.swing.*;
import static pages.utils.UISettings.*;

import main.Main;


public class Popup {

    // Method to show an error message popup
    public static void showErr(String message) {
        UIManager.put("OptionPane.messageForeground", DEFAULT_FOREGROUND);
        String htmlMessage = "<html><body><p style='padding: 10px;'>" + message + "</p></body></html>";
        JOptionPane.showMessageDialog(Main.getFrame(), htmlMessage, "Error", JOptionPane.ERROR_MESSAGE);
    }

    // Method to show an information message popup
    public static void showMsg(String message) {
        UIManager.put("OptionPane.messageForeground", DEFAULT_FOREGROUND);
        String htmlMessage = "<html><body><p style='padding: 10px;'>" + message + "</p></body></html>";
        JOptionPane.showMessageDialog(Main.getFrame(), htmlMessage, "Information", JOptionPane.INFORMATION_MESSAGE);
    }

    public static int showConfirm(String message) {
        UIManager.put("OptionPane.messageForeground", DEFAULT_FOREGROUND);
        String htmlMessage = "<html><body><p style='padding: 10px;'>" + message + "</p></body></html>";
        return JOptionPane.showConfirmDialog(Main.getFrame(), htmlMessage, "Confirm", JOptionPane.YES_NO_OPTION);
    }

}