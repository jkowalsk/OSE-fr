//! OSE spell description
//!

use crate::markdown_helper::markdown_to_tex;
use std::fmt::Write;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

#[derive(Default, Clone, Debug)]
pub struct Spell {
    name: String,
    mage_level: Option<u8>,
    clerc_level: Option<u8>,
    portee: String,
    duree: String,
    description: String,
}

impl Spell {
    pub fn from_md<P>(path: P) -> io::Result<Spell>
    where
        P: AsRef<Path>,
    {
        let file = File::open(path)?;
        let mut spell = Spell::default();
        let mut lines = io::BufReader::new(file).lines().peekable();
        let mut in_desc = false;

        while let Some(line) = lines.next() {
            let line = line?;
            if line.is_empty() && !in_desc {
            } else if line.starts_with("# ") {
                spell.name = line[2..].to_string();
            } else if let Some(l) =
                line.strip_prefix("*[Sorts de magicien](../Sorts_de_magicien.md) ")
            {
                spell.mage_level = Some(l.as_bytes()[0] - '0' as u8);
            } else if let Some(l) = line.strip_prefix("*[Sorts de clerc](../Sorts_de_clerc.md) ") {
                spell.clerc_level = Some(l.as_bytes()[0] - '0' as u8);
            } else if let Some(l) = line.strip_prefix("**Durée :** ") {
                spell.duree = l.to_string();
            } else if let Some(l) = line.strip_prefix("**Portée :** ") {
                spell.portee = l.to_string();
            } else {
                in_desc = true;
                if line.starts_with("###") {
                    return Ok(spell);
                }
                writeln!(spell.description, "{}", line).unwrap();
            }
        }
        Ok(spell)
    }

    pub fn to_tex<P>(&self, out: &mut P) -> io::Result<()>
    where
        P: io::Write,
    {
        writeln!(out, "\\begin{{spell}}")?;
        writeln!(out, "\\spellcarac{{name}}{{{}}}", self.name)?;
        if let Some(n) = self.mage_level {
            writeln!(out, "\\spellcarac{{level}}{{{}}}", n)?;
        } else if let Some(n) = self.clerc_level {
            writeln!(out, "\\spellcarac{{level}}{{{}}}", n)?;
        } else {
            return Err(io::Error::from(std::io::ErrorKind::InvalidInput));
        }
        writeln!(out, "\\spellcarac{{duree}}{{{}}}", self.duree)?;
        writeln!(out, "\\spellcarac{{portee}}{{{}}}", self.portee)?;
        writeln!(
            out,
            "\\spellcarac{{description}}{{{}}}",
            markdown_to_tex(&self.description)
        )?;
        writeln!(out, "\\end{{spell}}")?;
        Ok(())
    }
}

mod test {
    use super::*;
    use std::io::{BufWriter, Write};
    use std::path::Path;
    use std::{fs, io};

    #[test]
    fn spell_from_file() -> std::io::Result<()> {
        let spell = super::Spell::from_md("../src/Magie/Sorts/Abaissement_des_eaux.md")?;
        let mut stdout = std::io::stdout();
        spell.to_tex(&mut stdout)?;
        Ok(())
    }

    #[test]
    fn all_spells() -> std::io::Result<()> {
        let mut paths: Vec<_> = fs::read_dir("../src/Magie/Sorts/")?
            .filter_map(|r| r.ok())
            .collect();
        paths.sort_by_key(|de| de.file_name());

        let mut mage_spells = Vec::new();
        let mut cleric_spells = Vec::new();
        for path in paths {
            let path = path.path();
            let spell = Spell::from_md(path)?;
            if let Some(_n) = spell.mage_level {
                mage_spells.push(spell);
            } else if let Some(_n) = spell.clerc_level {
                cleric_spells.push(spell);
            } else {
                return Err(io::Error::from(std::io::ErrorKind::InvalidInput));
            }
        }

        let mut all_mage_spells = BufWriter::new(
            File::create("../spell_latex/liste/all_mage_spells.tex")
                .expect("Unable to create file"),
        );
        let outdir = "../spell_latex/liste/mage/";
        for spell in mage_spells {
            let filename = str::replace(&spell.name.clone(), " ", "_");
            writeln!(all_mage_spells, "\\input{{liste/mage/{}.tex}}", filename)?;
            let mut out = Path::new(outdir).join(filename);
            out.set_extension("tex");
            let f = File::create(out).expect("Unable to create file");
            let mut f = BufWriter::new(f);
            spell.to_tex(&mut f).expect("Unable to write file");
        }
        let mut all_cleric_spells = BufWriter::new(
            File::create("../spell_latex/liste/all_cleric_spells.tex")
                .expect("Unable to create file"),
        );
        let outdir = "../spell_latex/liste/clerc/";
        for spell in cleric_spells {
            let filename = str::replace(&spell.name.clone(), " ", "_");
            writeln!(all_cleric_spells, "\\input{{liste/clerc/{}.tex}}", filename)?;
            let mut out = Path::new(outdir).join(filename);
            out.set_extension("tex");
            let f = File::create(out).expect("Unable to create file");
            let mut f = BufWriter::new(f);
            spell.to_tex(&mut f).expect("Unable to write file");
        }

        Ok(())
    }
}
