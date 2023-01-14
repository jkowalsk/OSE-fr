//! Définition de monstre
//!
use crate::stats::*;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use crate::markdown_helper::markdown_to_tex;

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
            description: if vals[2].len() < 1 {
                String::new()
            } else {
                vals[2][1..].to_string()
            }
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
    pub fn from_md<P>(path: P) -> io::Result<Vec<Monstre>> 
    where P: AsRef<Path> {
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
                current.nom = line[2..].trim().to_string();
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
                    detail.description.push_str("\n"); // keep new lines
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

    pub fn to_tex<P>(&self, out: &mut P) -> io::Result<()>  where P: io::Write {
        writeln!(out, "\\begin{{monster}}")?;
        writeln!(out, "\\monstercarac{{name}}{{{}}}", self.nom)?;
        
        writeln!(out, "\\monstercarac{{description}}{{")?;
        for desc in &self.description {
            writeln!(out, "  {}", markdown_to_tex(desc))?;
        }
        writeln!(out, "}}")?;
        
        for detail in &self.details {
            writeln!(out, "\\monsterdetail{{{}}}{{{}}}", detail.nom, markdown_to_tex(&detail.description))?;
        }

        writeln!(out, "\\monstercarac{{ca}}{{{}}}", self.stats.ca.0)?;
        writeln!(out, "\\monstercarac{{hd}}{{{}}}", self.stats.hd.0)?;
        writeln!(out, "\\monstercarac{{taco}}{{{}}}", self.stats.taco.0)?;
        writeln!(out, "\\monstercarac{{moral}}{{{}}}", self.stats.moral.0)?;
        writeln!(out, "\\monstercarac{{alignement}}{{{}}}", self.stats.alignement.0)?;
        writeln!(out, "\\monstercarac{{xp}}{{{}}}", self.stats.xp.0)?;
        writeln!(out, "\\monstercarac{{nombre_donjon}}{{{}}}", self.stats.nombre.donjon)?;
        writeln!(out, "\\monstercarac{{nombre_exterieur}}{{{}}}", self.stats.nombre.exterieur)?;
        writeln!(out, "\\monstercarac{{tresor}}{{{}}}", self.stats.tresor.0)?;

        writeln!(out, "\\monstercarac{{mvt}}{{{}}}", self.stats.mouvement)?;

        writeln!(out, "\\monstercarac{{save_mort_poison}}{{{}}}", self.stats.sauvegarde.mort_poison)?;
        writeln!(out, "\\monstercarac{{save_baguettes}}{{{}}}", self.stats.sauvegarde.baguettes)?;
        writeln!(out, "\\monstercarac{{save_paralysie_petrification}}{{{}}}", self.stats.sauvegarde.paralysie_petrification)?;
        writeln!(out, "\\monstercarac{{save_souffles}}{{{}}}", self.stats.sauvegarde.souffles)?;
        writeln!(out, "\\monstercarac{{save_sorts_sceptres_batons}}{{{}}}", self.stats.sauvegarde.sorts_sceptres_batons)?;

        for attack in &self.stats.attacks.0 {
            writeln!(out, "\\monsterattack{{{}}}{{{}}}", attack.description, attack.effet)?;
        }

        writeln!(out, "\\end{{monster}}")?;
        Ok(())
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
        let monsters = super::Monstre::from_md("../src/Monstres/liste/Vampire.md")?;

        for monstre in monsters {
            println!("{:?}\n", monstre);
        }
        Ok(())
    }

    #[test]
    fn monster_from_file2() -> std::io::Result<()> {
        let monsters = super::Monstre::from_md("../src/Monstres/liste/Basilic.md")?;
        let mut stdout = std::io::stdout();
        for monstre in monsters {
            monstre.to_tex(&mut stdout).unwrap();
        }
        Ok(())
    }

    #[test]
    fn monster_to_tex() -> std::io::Result<()> {
        let monsters = super::Monstre::from_md("../src/Monstres/liste/Dragon.md")?;
        let mut stdout = std::io::stdout();
        for monstre in monsters {
          monstre.to_tex(&mut stdout).unwrap();
        }
        Ok(())
    }
}
