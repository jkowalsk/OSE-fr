use std::{process::{Command,Stdio}, io::Write};

pub fn markdown_to_tex(input: &str) -> String {
    let moved = String::from(input);
    let pandoc_args = vec!["-f", "markdown", "-t", "latex"];
    let mut pandoc_cmd = Command::new("pandoc").stdin(Stdio::piped()).stdout(Stdio::piped()).args(pandoc_args).spawn().expect("failed to execute echo");
    let mut stdin = pandoc_cmd.stdin.take().expect("Failed to open stdin");
    std::thread::spawn(move || {
        stdin.write_all(moved.as_bytes()).expect("Failed to write to stdin");
    });
    let output = pandoc_cmd.wait_with_output().expect("Failed to read stdout");
    String::from_utf8_lossy(&output.stdout).to_string()
}

mod test {
     
    #[test]
    fn basic() {
        let s = super::markdown_to_tex("texte1 **text bold** __text it__ **second**");
        println!("got : {}", s);
    }
}