//! Définition de monstre
//!
use crate::stats::*;
use std::fs::File;
use std::io::{self, BufRead};

#[derive(Default, Clone, Debug)]
pub struct Details {
    pub nom: String,
    pub description: String,
}

impl Details {
    pub fn from(content: String) -> Self {
        let vals: Vec<&str> = content.split("**").collect();
        let mut nom = vals[1].to_string();
        nom.pop();
        nom.pop();
        Details {
            nom,
            description: vals[2][1..].to_string(),
        }
    }
}

#[derive(Default, Clone, Debug)]
pub struct Monstre {
    pub nom: String,
    pub description: Vec<String>,
    pub stats: StatBlock,
    pub details: Vec<Details>,
}

impl Monstre {
    pub fn from_md(path: &str) -> io::Result<Vec<Monstre>> {
        let file = File::open(path)?;
        let mut res = Vec::new();

        let mut monster = Monstre::default();
        let mut current = &mut monster;

        let mut lines = io::BufReader::new(file).lines().peekable();

        while let Some(line) = lines.next() {
            let mut line = line?;
            if line.starts_with("# ") {
                current.nom = line[2..].to_string();
            } else if line.starts_with("## ") {
                res.push(Monstre::default());
                let last = res.len() - 1;
                current = &mut res[last];
                current.nom = line[2..].to_string();
                current.description = monster.description.clone();
                current.details = monster.details.clone();
            } else if line.starts_with("*") {
                let mut description = line[1..].to_string();
                loop {
                    if line.ends_with("*") {
                        description.pop(); // remove *
                        break;
                    }
                    line = lines.next().unwrap().unwrap();
                    description.push_str(" ");
                    description.push_str(&line);
                }
                current.description.push(description);
            } else if line.starts_with("  - ") {
                let mut detail = Details::from(line);
                loop {
                    let next = match lines.peek() {
                        Some(Ok(c)) => {
                            if c.starts_with("    ") {
                                &c[3..]
                            } else {
                                break;
                            }
                        }
                        _ => break,
                    };
                    detail.description.push_str(next);
                    let _ = lines.next();
                }
                current.details.push(detail);
            } else if line.starts_with("| ") {
                current.stats = StatBlock::from(&mut lines);
            }
        }
        if res.is_empty() {
            res.push(monster)
        }

        Ok(res)
    }
}

mod test {

    #[test]
    fn details_from() {
        let content =
            String::from("  - **Dressage :** Peut être dressé en tant qu’animal gardien ou de");
        let det = super::Details::from(content);
        println!("{:?}", det);
    }

    #[test]
    fn monster_from_file() -> std::io::Result<()> {
        let monsters = super::Monstre::from_md("../src/Monstres/liste/Aigle.md")?;

        for monstre in monsters {
            println!("{:?}\n", monstre);
        }
        Ok(())
    }

    #[test]
    fn monster_from_file2() -> std::io::Result<()> {
        let monsters = super::Monstre::from_md("../src/Monstres/liste/Basilic.md")?;

        for monstre in monsters {
            println!("{:?}\n", monstre);
        }
        Ok(())
    }
}
