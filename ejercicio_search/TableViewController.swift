//
//  TableViewController.swift
//  ejercicio_search
//
//  Created by Dianelys Saldaña on 11/15/23.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    let contenido = ["En","un","lugar","de","la","mancha"]
    
    private var searchController : UISearchController?
    private var searchResults = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "Búsqueda"
        
        // Creamos una tabla alternativa para visualizar los resultados cuando se seleccione la búsqueda
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self

        // Asignamos esta tabla a nuestro controlador de búsqueda
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController?.searchResultsUpdater = self

        // Especificamos el tamaño de la barra de búsqueda
        if let frame = self.searchController?.searchBar.frame {
            self.searchController?.searchBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 44.0)
        }

        // La añadimos a la cabecera de la tabla
        self.tableView.tableHeaderView = self.searchController?.searchBar

        // Esto es para indicar que nuestra vista de tabla de búsqueda se superpondrá a la ya existente
        self.definesPresentationContext = true


    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let src = self.searchController?.searchResultsController as! UITableViewController

        if tableView == src.tableView {
            return self.searchResults.count
        }
        else {
            return self.contenido.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let src = self.searchController?.searchResultsController as! UITableViewController
        let object : String?

        if tableView == src.tableView {
            object = self.searchResults[indexPath.row]
        }
        else {
            object = contenido[indexPath.row]
        }

        cell.textLabel!.text = object
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Cogemos el texto introducido en la barra de búsqueda
        let searchString = self.searchController?.searchBar.text


        // Si la cadena de búsqueda es vacía, copiamos en searchResults todos los objetos
        if searchString == nil || searchString == "" {
            self.searchResults = self.contenido
        }
        // Si no, copiamos en searchResults sólo los que coinciden con el texto de búsqueda
        else {
            let searchPredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", searchString!)
            let array = (self.contenido as NSArray).filtered(using: searchPredicate)
            self.searchResults = array as! [String]
        }

        // Recargamos los datos de la tabla
        let tvc = self.searchController?.searchResultsController as! UITableViewController
        tvc.tableView.reloadData()

        // Deseleccionamos la celda de la tabla principal
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at:selected, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object : String

        if let indexPath = self.tableView.indexPathForSelectedRow {
            object = self.contenido[indexPath.row]
        }
        else {
            let sc = self.searchController?.searchResultsController as! UITableViewController
            object = self.searchResults[(sc.tableView.indexPathForSelectedRow?.row)!]
        }
        print (object)
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
