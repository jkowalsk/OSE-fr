//! OSE statistitcs
//!

use std::fs::File;
use std::io::{BufReader, Lines};
use std::iter::Peekable;

#[derive(Default, Clone, Debug)]
pub struct Saves {
    pub mort_poison: String,
    pub baguettes: String,
    pub paralysie_petrification: String,
    pub souffles: String,
    pub sorts_sceptres_batons: String,
}

impl Saves {
    pub fn from(val: &str) -> Self {
        let mut ret = Saves::default();
        let mut vals = val.split(" ").map(|x| x.to_string());

        while let Some(val) = vals.next() {
            let val = val.trim();
            match val {
                "MP" => {
                    if let Some(val) = vals.next() {
                        ret.mort_poison = val.trim().into();
                    }
                }
                "B" => {
                    if let Some(val) = vals.next() {
                        ret.baguettes = val.trim().into();
                    }
                }
                "PP" => {
                    if let Some(val) = vals.next() {
                        ret.paralysie_petrification = val.trim().into();
                    }
                }
                "S" => {
                    if let Some(val) = vals.next() {
                        ret.souffles = val.trim().into();
                    }
                }
                "SSB" => {
                    if let Some(val) = vals.next() {
                        ret.sorts_sceptres_batons = val.trim().into();
                    }
                }
                _ => {}
            }
        }

        ret
    }
}

#[derive(Default, Clone, Debug)]
pub struct Ca(pub String);

#[derive(Default, Clone, Debug)]
pub struct Hd(pub String);

#[derive(Default, Clone, Debug)]
pub struct Attaque {
    pub description: String,
    pub effet: String,
}

impl Attaque {
    pub fn from(val: &str) -> Self {
        let vals: Vec<String> = val.split("(").map(|x| x.to_string()).collect();
        let description = vals[0].clone();
        let effet = vals[1].clone().trim().into();
        Attaque { description, effet }
    }
}

#[derive(Default, Clone, Debug)]
pub struct Attaques(pub Vec<Attaque>);
impl Attaques {
    pub fn from(val: &str) -> Self {
        let mut attacks = Vec::new();
        let vals: Vec<&str> = val.split(", ").collect();
        for val in vals {
            attacks.push(Attaque::from(val))
        }
        Attaques(attacks)
    }
}

#[derive(Default, Clone, Debug)]
pub struct Taco(pub String);

#[derive(Default, Clone, Debug)]
pub struct Mouvement {
    pub base: String,
    pub rencontre: String,
}

impl Mouvement {
    pub fn from(val: &str) -> Self {
        let vals: Vec<String> = val.split("(").map(|x| x.to_string()).collect();
        let base = vals[0].clone();
        let rencontre = vals[1].clone().trim().into();
        Mouvement { base, rencontre }
    }
}

#[derive(Default, Clone, Debug)]
pub struct Moral(pub String);

#[derive(Default, Clone, Debug)]
pub struct Alignement(pub String);

#[derive(Default, Clone, Debug)]
pub struct Xp(pub String);

#[derive(Default, Clone, Debug)]
pub struct Nombre {
    pub donjon: String,
    pub exterieur: String,
}

impl Nombre {
    pub fn from(val: &str) -> Self {
        let vals: Vec<String> = val.split("(").map(|x| x.to_string()).collect();
        let donjon = vals[0].trim().into();
        let exterieur = vals[1].trim().into();
        Nombre { donjon, exterieur }
    }
}

#[derive(Default, Clone, Debug)]
pub struct Tresor(pub String);

#[derive(Default, Clone, Debug)]
pub struct StatBlock {
    pub ca: Ca,
    pub hd: Hd,
    pub attacks: Attaques,
    pub taco: Taco,
    pub mouvement: Mouvement,
    pub sauvegarde: Saves,
    pub moral: Moral,
    pub alignement: Alignement,
    pub xp: Xp,
    pub nombre: Nombre,
    pub tresor: Tresor,
}

impl StatBlock {
    pub fn from(lines: &mut Peekable<Lines<BufReader<File>>>) -> Self {
        let mut res = StatBlock::default();
        while let Some(line) = lines.next() {
            let line = line.unwrap();
            let vals: Vec<&str> = line.split("|").collect();
            if vals.len() != 4 {
                break;
            }
            if line.starts_with("| Classe ") {
                res.ca = Ca(vals[2].trim().replace("\\", ""));
            } else if line.starts_with("| Dés") {
                res.hd = Hd(vals[2].trim().replace("\\", ""));
            } else if line.starts_with("| Att") {
                res.attacks = Attaques::from(&vals[2].trim());
            } else if line.starts_with("| TAC0") {
                res.taco = Taco(vals[2].trim().replace("\\", ""))
            } else if line.starts_with("| Dép") {
                res.mouvement = Mouvement::from(&vals[2].trim());
            } else if line.starts_with("| Jets ") {
                res.sauvegarde = Saves::from(&vals[2].trim());
            } else if line.starts_with("| Moral") {
                res.moral = Moral(vals[2].trim().replace("\\", ""));
            } else if line.starts_with("| Al") {
                res.alignement = Alignement(vals[2].trim().replace("\\", ""));
            } else if line.starts_with("| XP") {
                res.xp = Xp(vals[2].trim().replace("\\", ""));
            } else if line.starts_with("| Nombre ") {
                res.nombre = Nombre::from(&vals[2].replace("\\", ""));
            } else if line.starts_with("| Type") {
                res.tresor = Tresor(vals[2].trim().replace("\\", ""));
            } else if line.is_empty() {
                break;
            }
        }
        res
    }
}
