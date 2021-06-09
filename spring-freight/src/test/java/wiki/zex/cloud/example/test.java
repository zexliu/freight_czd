package wiki.zex.cloud.example;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class test {
    public static void main(String[] args) {

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String pasw = passwordEncoder.encode("6a204bd89f3c8348afd5c77c717a097a");
        System.out.println(pasw
        );
    }
}
