import { Pais } from "./pais";
import { Tipo } from "./tipo";


export interface Festivo{
  id: number;
  dia: number;
  mes: number;
  nombre: string;
  idTipo: number;
  diasPascua: number;
  tipo: Tipo;
  pais: Pais;
}
